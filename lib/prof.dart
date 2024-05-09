import 'package:flutter/material.dart';

import 'global.dart';

class Prof extends StatefulWidget {
  const Prof({super.key});

  @override
  _ProfState createState() => _ProfState();
}

class _ProfState extends State<Prof> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    // Завантаження даних користувача при ініціалізації
    final user = authManager.currentUser;
    if (user != null) {
      _userName = user.firstName;
      _userEmail = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Фон сторінки
      appBar: AppBar(
        title: const Text(
          'Profile', // Текст заголовку
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[50], // Фон аплікаційної смуги
        elevation: 0, // Видаляємо тінь аплікаційної смуги
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _userName, // Ім'я користувача
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _userEmail, // Email користувача
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Додати функціональність кнопки "Edit Profile"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}