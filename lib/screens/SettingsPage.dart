import 'package:flutter/material.dart';
import 'package:ruznama/screens/UserProfilePage.dart';
import 'package:ruznama/theme/app_colors.dart';
import 'package:ruznama/screens/CitySelectorModal.dart'; // если есть отдельный файл с выбором города
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _openCitySelector(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('selectedCity');

showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: true,
  builder: (_) => CitySelectorModal(
    selectedCity: 'Махачкала', // или null
    onCitySelected: (city) {
      print('Выбран город: $city');
    },
  ),
);

  }

  void _openUserProfile(BuildContext context) {
   showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: true,
  builder: (_) => const UserProfilePage(),
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // Профиль
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.white),
              title: const Text('Профиль', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () => _openUserProfile(context),
            ),

            // Город
            ListTile(
              leading: const Icon(Icons.location_city, color: Colors.white),
              title: const Text('Выбрать город', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
              onTap: () => _openCitySelector(context),
            ),

            const Divider(color: Colors.white24, height: 32),

            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Уведомления', style: TextStyle(color: Colors.white)),
              activeColor: AppColors.accent1Start,
            ),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text('О приложении', style: TextStyle(color: Colors.white)),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Ruznama',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2025 Simolapps',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
