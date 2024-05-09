import 'package:flutter/material.dart';

class Prof extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Фон сторінки
      appBar: AppBar(
        title: Text(
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
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'John Doe', // Ім'я користувача
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'john.doe@example.com', // Email користувача
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Функціональність кнопки "Edit Profile"
              },
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
