import 'package:flutter/material.dart';
import 'package:lab1sample2/storage/auth_manager.dart';
import 'package:lab1sample2/widgets/password_widget.dart';

import 'global.dart';
import 'helpers/validators.dart';
import 'internet_status_banner.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class Reg extends StatefulWidget {
  const Reg({super.key});

  @override
  _RegState createState() => _RegState();
}

class _RegState extends State<Reg> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text(
            'REGISTRATION',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue[50],
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: Validators.validateName,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    validator: Validators.validateSurName,
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: 'Surname',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    validator: Validators.validateEmail, // Додаємо функцію перевірки
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Перевіряємо валідність форми
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordWidget(
                              name: _nameController.text,
                              surname: _surnameController.text,
                              email: _emailController.text)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
