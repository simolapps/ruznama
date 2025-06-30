import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruznama/theme/app_colors.dart';

class CitySelectorModal extends StatefulWidget {
  final String? selectedCity;
  final Function(String) onCitySelected;

  const CitySelectorModal({
    super.key,
    required this.selectedCity,
    required this.onCitySelected,
  });

  @override
  State<CitySelectorModal> createState() => _CitySelectorModalState();
}

class _CitySelectorModalState extends State<CitySelectorModal> {
  List<String> _cities = [];
  String? _selected;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedCity;
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final res = await http.get(Uri.parse('https://simolapps.ru/api/namaz/get_cities.php'));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          _cities = data.map((e) => e['name'].toString()).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCity', city);
    widget.onCitySelected(city);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Выберите город',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final isSelected = city == _selected;
                      return ListTile(
                        title: Text(
                          city,
                          style: TextStyle(
                            color: isSelected ? AppColors.accent1Start : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: AppColors.accent1Start)
                            : null,
                        onTap: () => _selectCity(city),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
