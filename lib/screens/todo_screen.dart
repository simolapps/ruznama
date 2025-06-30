// Полный рабочий экран со сворачиваемым календарём (неделя / месяц)
// и корректной отрисовкой кружков прогресса для любого дня.

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ruznama/data/app_database.dart';

import 'package:ruznama/model/task.dart';
import 'package:ruznama/widgets/calendar_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../data/city_repository.dart';
import '../data/prayer_repository.dart';




class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // ─── данные ────────────────────────────────────────────────────────────
  final _repo = PrayerRepository(http.Client());
  final Map<DateTime, PrayerTime> _prayerCache = {}; // день → времена
  late List<Task> _tasks;
  late Map<DateTime, int> _totalTasksMap;

  City? _city;
  DateTime _day = DateTime.now();
  bool _firstLoad = true; // нужно ли показать первый спиннер
  Timer? _ticker;

  // ─── drag/overlay поля (без изменений) ────────────────────────────────
  Task? _draggingTask;
  OverlayEntry? _timeOverlay;
  late DateTime _dragStartTime;
  static const _pxPerMinute = 4.0;
  DateTime _previewTime = DateTime.now();
  Timer? _overlayHideTimer;
  static const _overlayHideDelay = Duration(seconds: 3);
  bool _loading = false;

  // ─── lifecycle ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _tasks = [];
    _init();
    _ticker =
        Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _overlayHideTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    await _restoreCity();
    if (_city != null) {
      await _ensurePrayerDay(_day); // быстрый запрос на один день
      _loadMonthInBackground(_day); // без блокировки
    }
    setState(() => _firstLoad = false);
  }

  // ─── City ──────────────────────────────────────────────────────────────
  Future<void> _restoreCity() async {
    final sp = await SharedPreferences.getInstance();
    final id = sp.getInt('city_id');
    final name = sp.getString('city_name');
    if (id != null) _city = City(id: id, name: name ?? 'City $id', selected: false);


    await _loadTasks();
    await _ensurePrayerMonth(_day); // ← ЭТОТ метод должен быть тут в этом классе
    setState(() {});
  }

  Future<void> _ensurePrayerMonth(DateTime anyDay) async {
    if (_city == null) return;
    final first = DateTime(anyDay.year, anyDay.month, 1);
    final days = DateUtils.getDaysInMonth(anyDay.year, anyDay.month);

    if (!_prayerCache.containsKey(first)) {
      setState(() => _loading = true);
      for (int d = 0; d < days; d++) {
        final date = first.add(Duration(days: d));
        _prayerCache[date] = (await _repo.fetchDay(_city!.id, date)) as PrayerTime;
      }
      setState(() => _loading = false);
    }
  }

  Future<void> _saveCity(City c) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('city_id', c.id);
    await sp.setString('city_name', c.name);
  }

  Future<void> _selectCity() async {
    final list = await CityRepository().fetchAll();
    if (list.isEmpty) return;
    _city = list.first;
    await _saveCity(_city!);
    setState(() {});
    await _ensurePrayerDay(_day);
    _loadMonthInBackground(_day);
  }

  // ─── Prayer loading ────────────────────────────────────────────────────
  Future<void> _ensurePrayerDay(DateTime d) async {
    if (_city == null || _prayerCache.containsKey(d)) return;
    _prayerCache[d] = (await _repo.fetchDay(_city!.id, d)) as PrayerTime;
  }

  void _loadMonthInBackground(DateTime anyDay) {
    final first = DateTime(anyDay.year, anyDay.month, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(anyDay.year, anyDay.month);

    // если уже есть весь месяц — ничего не делаем
    final already = List.generate(daysInMonth, (i) => first.add(Duration(days: i)))
        .every(_prayerCache.containsKey);
    if (already) return;

    // грузим параллельно, UI не блокируем
    Future.wait(List.generate(daysInMonth, (i) async {
      final date = first.add(Duration(days: i));
      if (!_prayerCache.containsKey(date)) {
        _prayerCache[date] = (await _repo.fetchDay(_city!.id, date)) as PrayerTime;
        if (mounted) setState(() {}); // обновлять кружки по мере прихода
      }
    }));
  }

  // ─── Tasks storage ─────────────────────────────────────────────────────
  Future<void> _loadTasks() async {
    final sp = await SharedPreferences.getInstance();
    _tasks = Task.decode(sp.getStringList('tasks') ?? []);
  }

  Future<void> _saveTasks() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('tasks', Task.encode(_tasks));
  }

  // ─── helpers для Progress карт ─────────────────────────────────────────
  Map<DateTime, int> _completedPrayersMonth(DateTime month) {
    final today = DateTime.now();
    final res = <DateTime, int>{};
    _prayerCache.forEach((date, p) {
      if (date.year == month.year && date.month == month.month) {
        final times = [
          _parse(date, p.morning),
          _parse(date, p.noon),
          _parse(date, p.afternoon),
          _parse(date, p.sunset),
          _parse(date, p.night),
        ];
        res[date] = times.where((t) => t.isBefore(today)).length;
      }
    });
    return res;
  }

  Map<DateTime, int> _completedTasks() {
    final done = <DateTime, int>{};
    final total = <DateTime, int>{};
    for (final t in _tasks) {
      final key = DateTime(t.time.year, t.time.month, t.time.day);
      total[key] = (total[key] ?? 0) + 1;
      if (t.done) done[key] = (done[key] ?? 0) + 1;
    }
    _totalTasksMap = total;
    return done;
  }

  // ─── UI ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_city == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: _selectCity, child: const Text('Выбрать город')),
        ),
      );
    }

    if (_firstLoad || !_prayerCache.containsKey(_day)) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prayerDone = _completedPrayersMonth(_day);
    final taskDone = _completedTasks();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _buildFab(context),
      body: Column(
        children: [
          CalendarHeader(
            selectedDay: _day,
            onSelectDay: (d) async {
              setState(() => _day = d);
              await _ensurePrayerDay(d);
              _loadMonthInBackground(d);
            },
            completedPrayers: prayerDone,
            completedTasks: taskDone,
            totalTasks: _totalTasksMap,
          ),
          Expanded(child: _buildTimeline()),
        ],
      ),
    );
  }

  // ─── FAB ───────────────────────────────────────────────────────────────
  Widget _buildFab(BuildContext ctx) => Positioned(
        bottom: 90,
        right: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: FloatingActionButton(
              backgroundColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: () => _showTaskEditor(ctx),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      );

  // ─── timeline ──────────────────────────────────────────────────────────
  Widget _buildTimeline() {
    final p = _prayerCache[_day]!;
    final prayers = <_TimelineItem>[
      _TimelineItem('Фаджр', _parse(_day, p.morning), isPrayer: true),
      _TimelineItem('Восход', _parse(_day, p.sunrise), isPrayer: true),
      _TimelineItem('Зухр', _parse(_day, p.noon), isPrayer: true),
      _TimelineItem('Аср', _parse(_day, p.afternoon), isPrayer: true),
      _TimelineItem('Магриб', _parse(_day, p.sunset), isPrayer: true),
      _TimelineItem('Иша', _parse(_day, p.night), isPrayer: true),
    ];

    final tasks = _tasks
        .where((t) => _isSameDay(t.time, _day))
        .map((t) => _TimelineItem(t.title, t.time, isPrayer: false, task: t))
        .toList();

    final items = [...prayers, ...tasks]
      ..sort((a, b) => a.time.compareTo(b.time));
    final now = DateTime.now();

    final current = items.indexWhere((e) => e.time.isAfter(now));
    final currentPrayerIndex =
        items.indexWhere((e) => e.isPrayer && e.time.isAfter(now));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8, bottom: 155),
        physics: const BouncingScrollPhysics(),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            connectorTheme:
                ConnectorThemeData(color: Colors.white24, thickness: 2),
          ),
          builder: TimelineTileBuilder.connected(
            itemCount: items.length,
            connectionDirection: ConnectionDirection.before,
            contentsBuilder: (c, i) =>
                _buildTileContent(c, items, i, currentPrayerIndex),
            indicatorBuilder: (c, i) =>
                _buildIndicator(items, i, currentPrayerIndex, current),
            connectorBuilder: (c, i, __) => SolidLineConnector(
                color: i < current ? Colors.white : Colors.white24),
          ),
        ),
      ),
    );
  }

  Widget _buildTileContent(
      BuildContext ctx, List<_TimelineItem> items, int idx, int? currentPrayerIdx) {
    final it = items[idx];
    final isPrayer = it.isPrayer;
    final isCurrent = idx == currentPrayerIdx;
    const cardHeight = 60.0;
    final isSunrise = isPrayer && it.title == 'Восход';
    final isActive = !isPrayer && it.task == _draggingTask;

    final container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isPrayer
            ? const Color(0xFF1B1B1B)
            : (isActive ? const Color(0xFF3C3C3C) : const Color(0xFF262626)),
        borderRadius: BorderRadius.circular(isPrayer ? 8 : 6),
        border: isPrayer
            ? Border.all(
                color: isSunrise
                    ? Colors.amber.shade300
                    : (isCurrent
                        ? Colors.green
                        : const Color.fromARGB(96, 105, 240, 175)),
                width: 1,
              )
            : (isActive ? Border.all(color: Colors.blueAccent, width: 2) : null),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(it.title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          Text(DateFormat('HH:mm').format(it.time),
              style: const TextStyle(color: Colors.white60, fontSize: 16)),
        ],
      ),
    );

    if (isPrayer) {
      return _wrapCard(container, cardHeight, () {
        final suggested = _roundTo5(it.time.add(const Duration(minutes: 10)));
        _showTaskEditor(ctx, slotStart: suggested);
      });
    }

    final task = it.task!;
    return _wrapCard(
      container,
      cardHeight,
      () {},
      gesture: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _showTaskView(ctx, task),
        onLongPressStart: (_) => _beginAdjust(task),
        onLongPressMoveUpdate: (d) => _updateAdjust(d.offsetFromOrigin.dy),
        onLongPressEnd: (_) => _endAdjust(),
        child: container,
      ),
    );
  }

  Widget _buildIndicator(
      List<_TimelineItem> items, int idx, int? currentPrayerIdx, int current) {
    final it = items[idx];
    final passed = it.time.isBefore(DateTime.now());
    const base = 26.0;

    if (it.isPrayer) {
      final isCurrent = idx == currentPrayerIdx;
      final isSunrise = it.title == 'Восход';
      if (passed) {
        return DotIndicator(
          size: base,
          color: isSunrise ? Colors.amberAccent : Colors.green,
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      }
      return OutlinedDotIndicator(
        size: base,
        color: isSunrise
            ? Colors.amberAccent
            : (isCurrent ? Colors.green : Colors.white38),
        borderWidth: 2,
      );
    }

    final task = it.task!;
    return GestureDetector(
      onTap: () {
        setState(() => task.done = !task.done);
        _saveTasks();
      },
      child: task.done
          ? DotIndicator(
              size: base,
              color: task.color,
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            )
          : OutlinedDotIndicator(size: base, color: task.color, borderWidth: 2.5),
    );
  }

  // ─── утилиты ───────────────────────────────────────────────────────────
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _parse(DateTime base, String hhmm) {
    final p = hhmm.split(':').map(int.parse).toList();
    return DateTime(base.year, base.month, base.day, p[0], p[1]);
  }

  DateTime _roundTo5(DateTime t) =>
      DateTime(t.year, t.month, t.day, t.hour, (t.minute / 5).round() * 5);

  // ─── Обёртка карточки ──────────────────────────────────────────────────
  Widget _wrapCard(Widget container, double height, VoidCallback onTap,
      {GestureDetector? gesture}) {
    final child = gesture ??
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: container,
        );

    return Center(
      child: SizedBox(
        height: height,
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }

  // ─── Просмотр / редактор задачи, drag-overlay … (оставлены без изменений)
  // ... здесь остаётся ваш прежний _showTaskView, _showTaskEditor, overlay, drag-логика ...

  // ─── Helper for indicator overlay (оставляем как было)  ────────────────
  // ...

  //---------------_showTaskEditor

  void _showTaskEditor(BuildContext ctx, {DateTime? slotStart, Task? task}) {
    final ctrl = TextEditingController(text: task?.title ?? '');
    final noteCtrl = TextEditingController(text: task?.note ?? '');
    DateTime time = task?.time ?? slotStart ?? DateTime.now();
    Color color = task?.color ?? Colors.blue.shade300;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (formCtx, setSt) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task == null ? 'Новая задача' : 'Правка',
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              TextField(
                controller: ctrl,
                autofocus: false, // ✅ Теперь клавиатура не появляется сразу
                decoration: const InputDecoration(
                  labelText: 'Тема задачи',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Подробнее',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(DateFormat('HH:mm').format(time),
                      style: const TextStyle(color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.white),
                    onPressed: () async {
                      final p = await showTimePicker(
                        context: formCtx,
                        initialTime: TimeOfDay.fromDateTime(time),
                      );
                      if (p != null) {
                        time = DateTime(time.year, time.month, time.day, p.hour, p.minute);
                        setSt(() {});
                      }
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.palette, color: color),
                    onPressed: () async {
                      await showDialog(
                        context: formCtx,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          content: BlockPicker(
                            pickerColor: color,
                            onColorChanged: (c) => color = c,
                          ),
                        ),
                      );
                      setSt(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (ctrl.text.trim().isEmpty) return;
                  setState(() {
                    if (task == null) {
                      _tasks.add(Task(
                        title: ctrl.text.trim(),
                        time: time,
                        color: color,
                        note: noteCtrl.text.trim(),
                      ));
                    } else {
                      task
                        ..title = ctrl.text.trim()
                        ..time = time
                        ..color = color
                        ..note = noteCtrl.text.trim();
                    }
                  });
                  _saveTasks();
                  Navigator.pop(formCtx);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //-------------showTaskView

  void _showTaskView(BuildContext ctx, Task task) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white60, size: 20),
                const SizedBox(width: 6),
                Text(DateFormat('HH:mm').format(task.time),
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const Spacer(),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: task.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            if (task.note?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              const Text('Подробнее:',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(task.note!, style: const TextStyle(color: Colors.white)),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Редактировать'),
                  onPressed: () {
                    Navigator.pop(ctx); // закрываем просмотр
                    _showTaskEditor(ctx, task: task); // открываем редактор
                  },
                ),
                ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить'),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: ctx,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.grey.shade900,
                        title: const Text('Удалить задачу?',
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Вы уверены, что хотите удалить эту задачу?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Удалить',
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      setState(() {
                        _tasks.remove(task);
                      });
                      _saveTasks();
                      Navigator.pop(ctx); // закрываем после удаления
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── drag-overlay helpers ───────────────────────────────────────────────
  void _restartHideTimer() {
    _overlayHideTimer?.cancel();
    _overlayHideTimer = Timer(_overlayHideDelay, _hideTimeOverlay);
  }

  void _showTimeOverlay(DateTime t) {
    _previewTime = t;

    _timeOverlay = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: StatefulBuilder(
                builder: (_, setOverlayState) {
                  // Сохраняем setState для обновлений
                  _overlaySetState = setOverlayState;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat('HH:mm').format(_previewTime),
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_timeOverlay!);
    _restartHideTimer();
  }

  void Function(void Function())? _overlaySetState;

  void _updateTimeOverlay(DateTime t) {
    _previewTime = t;
    if (_overlaySetState != null) {
      _overlaySetState!(() {});
    }
    _restartHideTimer();
  }

  void _hideTimeOverlay() {
    _overlayHideTimer?.cancel();
    _overlayHideTimer = null;
    _timeOverlay?.remove();
    _timeOverlay = null;
  }

  // ─── drag-lifecycle ────────────────────────────────────────────────────
  void _beginAdjust(Task task) {
    setState(() => _draggingTask = task);
    _dragStartTime = task.time;
    _showTimeOverlay(_dragStartTime);
  }

  void _updateAdjust(double offsetDy) {
    if (_draggingTask == null) return; // страховка
    final task = _draggingTask!;

    final int step5 = (offsetDy / (_pxPerMinute * 5)).round();
    DateTime newTime = _dragStartTime.add(Duration(minutes: step5 * 5));

    newTime = DateTime(newTime.year, newTime.month, newTime.day, newTime.hour,
        (newTime.minute / 5).round() * 5);

    final dayStart =
        DateTime(_dragStartTime.year, _dragStartTime.month, _dragStartTime.day);
    final dayEnd = dayStart.add(const Duration(hours: 23, minutes: 55));

    if (newTime.isBefore(dayStart)) newTime = dayStart;
    if (newTime.isAfter(dayEnd)) newTime = dayEnd;

    final others = _tasks.where((t) =>
        t != task &&
        t.time.year == _day.year &&
        t.time.month == _day.month &&
        t.time.day == _day.day);

    final dir = step5 >= 0 ? 1 : -1;
    bool conflict;
    do {
      conflict = false;
      for (final o in others) {
        if ((o.time.difference(newTime).inMinutes).abs() < 5) {
          conflict = true;
          newTime = newTime.add(Duration(minutes: 5 * dir));
          newTime = DateTime(newTime.year, newTime.month, newTime.day, newTime.hour,
              (newTime.minute / 5).round() * 5);
          if (newTime.isBefore(dayStart)) newTime = dayStart;
          if (newTime.isAfter(dayEnd)) newTime = dayEnd;
          break;
        }
      }
    } while (conflict);

    setState(() => task.time = newTime);
    _updateTimeOverlay(newTime);
  }

  void _endAdjust() {
    setState(() => _draggingTask = null);
    _restartHideTimer();
    _saveTasks();
  }
}

// ─── внутренняя модель для таймлайна ─────────────────────────────────────
class _TimelineItem {
  final String title;
  final DateTime time;
  final bool isPrayer;
  final Task? task;
  _TimelineItem(this.title, this.time, {required this.isPrayer, this.task});
}