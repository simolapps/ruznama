import 'package:http/http.dart' as http;
import '../model/prayer_time.dart';

class PrayerRepository {
  final http.Client client;
  PrayerRepository(this.client);

  Future<PrayerTime> fetchDay(int cityId, DateTime date) async {
    // Dummy data for demo purposes
    return PrayerTime(
      morning: '05:00',
      sunrise: '06:30',
      noon: '12:00',
      afternoon: '15:30',
      sunset: '18:45',
      night: '20:00',
    );
  }
}
