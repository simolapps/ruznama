import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as d;
import 'package:ruznama/data/app_database.dart';
import 'package:ruznama/data/prayer_repository.dart';
import 'package:ruznama/theme/app_colors.dart';

class CitySelectorModal extends StatefulWidget {
  final City? selected;
  final Function(City) onCitySelected;
  const CitySelectorModal({super.key, required this.selected, required this.onCitySelected});

  @override State<CitySelectorModal> createState() => _CitySelectorModalState();
}

class _CitySelectorModalState extends State<CitySelectorModal> {
  final _db         = AppDatabase.instance;
  final _prayerRepo = PrayerRepository(http.Client());

  List<City> _cities = [];
  City?      _picked;
  bool       _loading = true;
  bool       _saving  = false;

  @override void initState() {
    super.initState();
    _picked = widget.selected;
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final res  = await http.get(Uri.parse('https://simolapps.ru/api/namaz/get_cities.php'));
      final list = (jsonDecode(res.body) as List).map((e) =>
          City(id: int.parse(e['id'].toString()),
               name: e['name'].toString(),
               selected: false)).toList();
      setState(() { _cities = list; _loading = false; });
    } catch (e) {
      debugPrint('Ошибка городов: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _select(City c) async {
    setState(() => _saving = true);

    // 1. обновляем таблицу cities
    await _db.transaction(() async {
      await (_db.update(_db.cities)..where((t) => t.selected.equals(true)))
          .write(const CitiesCompanion(selected: d.Value(false)));

      await _db.into(_db.cities).insertOnConflictUpdate(
        CitiesCompanion(id:d.Value(c.id), name:d.Value(c.name), selected:const d.Value(true)),
      );
    });

    // 2. качаем месяц намазов
    final month = await _prayerRepo.fetchMonth(c.id);

    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
        _db.prayerTimes,
        month.map((t) => PrayerTimesCompanion(
          cityId    : d.Value(c.id),
          date      : d.Value(t.date),
          morning   : d.Value(t.morning),
          sunrise   : d.Value(t.sunrise),
          noon      : d.Value(t.noon),
          afternoon : d.Value(t.afternoon),
          sunset    : d.Value(t.sunset),
          night     : d.Value(t.night),
        )).toList(),
      );
    });

    widget.onCitySelected(c.copyWith(selected: true));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*.85),
    decoration : const BoxDecoration(color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    padding: const EdgeInsets.all(20),
    child: _loading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Stack(children:[
            Column(children:[
              const Text('Выберите город',
                  style: TextStyle(color: Colors.white,fontSize:20,fontWeight:FontWeight.bold)),
              const SizedBox(height:16),
              Expanded(child: ListView.builder(
                itemCount:_cities.length,
                itemBuilder:(ctx,i){
                  final city=_cities[i]; final sel=city.id==_picked?.id;
                  return ListTile(
                    title:Text(city.name,
                      style:TextStyle(color: sel?AppColors.accent1Start:Colors.white,
                                      fontWeight: sel?FontWeight.bold:FontWeight.normal)),
                    trailing: sel?const Icon(Icons.check,color:AppColors.accent1Start):null,
                    onTap: ()=>_select(city),
                  );
                })),
            ]),
            if(_saving)
              Positioned.fill(child:Container(color:Colors.black54,
                child:const Center(child:CircularProgressIndicator(color:Colors.white)))),
          ]),
  );
}
