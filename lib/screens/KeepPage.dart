import 'package:flutter/material.dart';
import 'package:ruznama/theme/app_colors.dart';

class KeepPage extends StatelessWidget {
  const KeepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // две колонки
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: 10, // можно заменить на notes.length
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // стеклянная стилистика
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Заголовок заметки $index',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Expanded(
                    child: Text(
                      'Текст заметки. Можно хранить мысли, планы, цели и дуа...',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent1Start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () {
          // Открыть экран создания заметки
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
