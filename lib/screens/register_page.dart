// ... все импорты без изменений ...
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ruznama/widgets/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController(text: '8');
  final _codeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();

  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();

  bool isCodeSent = false;
  bool isCodeVerified = false;

  final String sendCodeUrl = 'https://simolapps.tw1.ru/api/send_code.php';
  final String verifyCodeUrl = 'https://simolapps.tw1.ru/api/verify_code.php';
  final String registerUserUrl = 'https://simolapps.tw1.ru/api/register_user_media.php';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    });
  }

  Future<void> _sendCode() async {
    final response = await http.post(
      Uri.parse(sendCodeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': _phoneController.text}),
    );
    final data = jsonDecode(response.body);
    if (data['success']) {
      setState(() {
        isCodeSent = true;
        FocusScope.of(context).requestFocus(_codeFocusNode);
      });
    }
  }

  Future<void> _verifyCode() async {
    final response = await http.post(
      Uri.parse(verifyCodeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': _phoneController.text,
        'code': _codeController.text
      }),
    );
    final data = jsonDecode(response.body);
    if (data['success']) {
      if (data['patient_exists']) {
        final prefs = await SharedPreferences.getInstance();
        final user = data['user'];
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', int.parse(user['id'].toString()));
        await prefs.setString('userName', user['first_name']);
        await prefs.setString('userPhone', _phoneController.text);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (_) => false,
          );
        }
      } else {
        setState(() => isCodeVerified = true);
      }
    }
  }

  Future<void> _registerUser() async {
    final response = await http.post(
      Uri.parse(registerUserUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': _phoneController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'middle_name': _middleNameController.text,
      }),
    );
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', int.parse(data['user_id'].toString()));
      await prefs.setString('userName', _firstNameController.text);
      await prefs.setString('userPhone', _phoneController.text);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (_) => false,
        );
      }
    }
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse('https://wa.me/79285147009');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть WhatsApp')),
      );
    }
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isCodeVerified) ...[
            TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox(height: 12),
            if (!isCodeSent)
              ElevatedButton(
                onPressed: _sendCode,
                child: const Text('Отправить код'),
              ),
            if (isCodeSent) ...[
              TextField(
                controller: _codeController,
                focusNode: _codeFocusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Код подтверждения',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Подтвердить код'),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              '📩 Код подтверждения будет отправлен на WhatsApp.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.white54),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat, color: Colors.greenAccent),
              label: const Text(
                'Написать в WhatsApp: \n +7 928 514-70-09',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
            ),
          ],
          if (isCodeVerified) ...[
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Фамилия'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _middleNameController,
              decoration: const InputDecoration(labelText: 'Отчество'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Завершить регистрацию'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: const Color(0xFF1F1F1F),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Регистрация'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 24),
                    _buildCard(child: SizedBox(width: 350, child: _buildForm())),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCard(child: _buildForm()),
                  ],
                ),
        ),
      ),
    );
  }
}
