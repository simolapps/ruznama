import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruznama/theme/app_colors.dart';
import 'package:ruznama/screens/UserProfilePage.dart';
import 'package:ruznama/screens/CitySelectorModal.dart';
import 'package:ruznama/data/app_database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    _restoreCity();
  }

  Future<void> _restoreCity() async {
    final prefs = await SharedPreferences.getInstance();
    final id   = prefs.getInt('city_id');
    final name = prefs.getString('city_name');
    if (id != null && name != null) {
      setState(() => _selectedCity = City(id: id, name: name, selected: false));
    }
  }

  void _openCitySelector(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CitySelectorModal(     // ← скобки добавлены!
        selected: _selectedCity,
        onCitySelected: (city) {
          setState(() => _selectedCity = city);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Выбран город: ${city.name}')),
          );
        },
      ),
    );
  }

  void _openUserProfile(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const UserProfilePage(),   // ← скобки добавлены!
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              const Text(
                'Настройки',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.white),
                title:
                    const Text('Профиль', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white54, size: 16),
                onTap: () => _openUserProfile(context),
              ),

              ListTile(
                leading: const Icon(Icons.location_city, color: Colors.white),
                title: const Text('Выбрать город',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  _selectedCity?.name ?? 'Не выбран',
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white54, size: 16),
                onTap: () => _openCitySelector(context),
              ),

              const Divider(color: Colors.white24, height: 32),

              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Уведомления',
                    style: TextStyle(color: Colors.white)),
                activeColor: AppColors.accent1Start,
              ),
            ],
          ),
        ),
      );
}
