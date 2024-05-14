import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lab1sample2/widgets/custom_text.dart';
import 'package:lab1sample2/widgets/custom_text_field.dart';
import 'global.dart';
import 'helpers/message.dart';
import 'internet_status_banner.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    if (authManager.isUserAuthenticated()) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<bool> _isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _showNoInternetDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please connect to the internet to proceed.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const CustomText(text: 'Barbershop Login'),
          backgroundColor: Colors.blue[50],
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/barb1.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool isInternetAvailable = await _isInternetAvailable();
                    if (!isInternetAvailable) {
                      await _showNoInternetDialog(context);
                      return;
                    }
      
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
      
                    bool success = await authManager.login(email, password);
      
                    if (success) {
                      storage.saveCurrentUser(email);
                      showSnackBar('Login successful!', Colors.green, context);
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      showSnackBar('Login failed! Invalid email or password.', Colors.red, context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
