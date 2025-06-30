import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/app_database.dart';   // для City класса

class CityRepository {
  Future<List<City>> fetchAll() async {
    final res = await http.get(
      Uri.parse('https://simolapps.ru/api/namaz/get_cities.php'),
    );
    if (res.statusCode != 200) return [];
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => City(
              id: int.parse(e['id'].toString()),
              name: e['name'].toString(),
              selected: false,
            ))
        .toList();
  }
}
