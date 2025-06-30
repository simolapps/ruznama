import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruznama/theme/app_colors.dart';
import 'package:ruznama/screens/register_page.dart';
import 'package:ruznama/widgets/MainScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? userName;
  String? userPhone;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  bool isSubscriptionActive = false;
  List<dynamic> subscriptionApps = [];

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getInt('userId');

    if (!logged || userId == null) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  RegisterPage()));
      }
      return;
    }

    userName  = prefs.getString('userName')  ?? '—';
    userPhone = prefs.getString('userPhone') ?? '—';
    subscriptionStartDate = prefs.getString('subscriptionStartDate');
    subscriptionEndDate   = prefs.getString('subscriptionEndDate');
    isSubscriptionActive  = prefs.getBool('isSubscriptionActive') ?? false;

    setState(() {});
    _refreshSubscription(userId);
  }

  Future<void> _refreshSubscription(int userId) async {
    try {
      final res = await http.post(
        Uri.parse('https://simolapps.tw1.ru/api/get_subscription.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] && data['subscription'] != null) {
          final sub = data['subscription'];
          setState(() {
            subscriptionStartDate = sub['start_date'];
            subscriptionEndDate   = sub['end_date'];
            isSubscriptionActive  = sub['is_active'] == 1;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _launchUri(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchApp(String scheme, String fallback) async {
    final uri = Uri.parse(scheme);
    if (!await canLaunchUrl(uri)) {
      await _launchUri(fallback);
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  RegisterPage()), (_) => false);
    }
  }

  Widget _gradientButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required Color start,
    required Color end,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [start, end]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
      ),
    );
  }

  Widget _contactRow(IconData ic, String scheme, String fallback, String label) {
    return Row(children: [
      IconButton(
        icon: FaIcon(ic, color: AppColors.accent1Start),
        onPressed: () => _launchApp(scheme, fallback),
      ),
      TextButton(
        onPressed: () => _launchApp(scheme, fallback),
        child: Text(label, style: const TextStyle(fontSize: 18, color: AppColors.accent1End)),
      ),
    ]);
  }

  Widget _profileCard() => Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ваш профиль', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Text('Имя: $userName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text('Телефон: $userPhone', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            _gradientButton(
              text: 'Выйти из профиля',
              icon: Icons.exit_to_app,
              onTap: _logout,
              start: Colors.grey.shade700,
              end: Colors.grey.shade600,
            ),
          ]),
        ),
      );

  Widget _contactCard() => Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Связаться с нами', style: TextStyle(fontSize: 20, color: AppColors.accent1End, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _contactRow(FontAwesomeIcons.whatsapp, 'whatsapp://send?phone=79285147009', 'https://wa.me/79285147009', '8‑928‑514‑70‑09'),
            _contactRow(FontAwesomeIcons.telegram, 'tg://resolve?domain=simolapps', 'https://t.me/simolapps', '@simolapps'),
            _contactRow(FontAwesomeIcons.instagram, 'instagram://user?username=simolapps', 'https://instagram.com/simolapps', '@simolapps'),
          ]),
        ),
      );

  Widget _subscriptionCard() {
    if (isSubscriptionActive) {
      return Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Подписка активна', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent1End)),
            const SizedBox(height: 6),
            Text('С $subscriptionStartDate по $subscriptionEndDate', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 14),
            const Text('Ваши преимущества', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...['Нет рекламы', 'Прослушивание офлайн', 'VPN‑доступ', 'Приложение «Mureed»']
                .map((f) => ListTile(leading: const Icon(Icons.check_circle, color: Colors.teal), title: Text(f))),
            if (subscriptionApps.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Доступно в приложениях', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...subscriptionApps.map((a) => Card(
                    child: ListTile(
                      leading: Image.network(a['icon_url'], width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.apps)),
                      title: Text(a['name']),
                      subtitle: Text(a['description']),
                    ),
                  )),
            ],
          ]),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Icon(Icons.lock_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text(
            'Чтобы слушать треки офлайн, получить VPN‑доступ,\n Pro версия «Mureed» \n и убрать рекламу — \n оформите подписку.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          _gradientButton(
            text: 'Оформить подписку',
            icon: Icons.shopping_cart_checkout,
            onTap: () => _launchUri('https://simolapps.ru'),
            start: AppColors.accent2Start,
            end: AppColors.accent2End,
          ),
          const SizedBox(height: 14),
          _gradientButton(
            text: 'СЛУШАТЬ ОНЛАЙН',
            icon: Icons.play_arrow_rounded,
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen())),
            start: AppColors.accent1Start,
            end: AppColors.accent1End,
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.95),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            _profileCard(),
            _contactCard(),
            _subscriptionCard(),
          ]),
        ),
      ),
    );
  }
}
