import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Змінюємо фон на блакитний
      appBar: AppBar(
        title: Text(
          'Barbershop Login', // Змінюємо текст заголовку
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[50], // Змінюємо фон аплікаційної смуги на блакитний
        elevation: 0, // Видаляємо тінь аплікаційної смуги
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Додаємо відступи
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Додаємо зображення бритви
              Image.asset(
                'assets/barb1.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Login',
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
      ),
    );
  }
}
