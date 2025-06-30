import '../model/city.dart';

class CityRepository {
  Future<List<City>> fetchAll() async {
    return [
      City(id: 1, name: 'City 1'),
      City(id: 2, name: 'City 2'),
    ];
  }
}
