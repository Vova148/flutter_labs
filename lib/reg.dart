import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REGISTRATION',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Reg(),
    );
  }
}

class Reg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Фон сторінки
      appBar: AppBar(
        title: Text(
          'REGISTRATION', // Змінюємо текст заголовку
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[50], // Фон аплікаційної смуги
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Змінюємо колір тексту
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Змінюємо колір тексту
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Змінюємо колір тексту
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordWidget()),
                );
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

class PasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Фон сторінки
      appBar: AppBar(
        title: Text(
          'CREATE PASSWORD', // Змінюємо текст заголовку
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[50], // Фон аплікаційної смуги
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Змінюємо колір тексту
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), // Змінюємо колір тексту
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Додайте функціональність для підтвердження паролю
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password confirmed!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: Text(
                'Confirm Password',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
