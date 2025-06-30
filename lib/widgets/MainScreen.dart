import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ruznama/screens/KeepPage.dart';
import 'package:ruznama/screens/SettingsPage.dart';
import 'package:ruznama/screens/todo_screen.dart';
import 'package:ruznama/screens/register_page.dart';
import 'package:ruznama/screens/UserProfilePage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TodoScreen(),
    KeepPage(),
    const SettingsPage(),
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _currentIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: const Color.fromARGB(255, 170, 170, 170),
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 24,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                            items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add_alt_1),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: '',
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

