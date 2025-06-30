import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/prayer_time.dart';

class PrayerRepository {
  final http.Client _client;
  PrayerRepository(this._client);

  /// вернуть все времена на месяц вперёд
  Future<List<PrayerTime>> fetchMonth(int cityId) async {
    final uri = Uri.parse(
      'https://simolapps.ru/api/namaz/get_times.php?city_id=$cityId',
    );
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Ошибка сети ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List;
    return list.map((j) => PrayerTime.fromJson(j)).toList();
  }

  /// вернуть конкретный день (если API только «месяц»)
  Future<PrayerTime> fetchDay(int cityId, DateTime date) async {
    final month = await fetchMonth(cityId);
    final key   = '${date.year.toString().padLeft(4, '0')}-'
                  '${date.month.toString().padLeft(2, '0')}-'
                  '${date.day.toString().padLeft(2, '0')}';
    return month.firstWhere(
      (p) => p.date == key,
      orElse: () => throw Exception('Нет данных на $key'),
    );
  }
}
