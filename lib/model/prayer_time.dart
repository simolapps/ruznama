class PrayerTime {
  final String date;     //  YYYY-MM-DD
  final String morning;
  final String sunrise;
  final String noon;
  final String afternoon;
  final String sunset;
  final String night;

  PrayerTime({
    required this.date,
    required this.morning,
    required this.sunrise,
    required this.noon,
    required this.afternoon,
    required this.sunset,
    required this.night,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> j) => PrayerTime(
        date       : j['date']     as String,
        morning    : j['morning']  as String,
        sunrise    : j['sunrise']  as String,
        noon       : j['noon']     as String,
        afternoon  : j['afternoon']as String,
        sunset     : j['sunset']   as String,
        night      : j['night']    as String,
      );
}
