import 'package:flutter/material.dart';

import '../global.dart';

class DrawerMain extends StatefulWidget {
  final String selected;

  const DrawerMain({super.key, required this.selected});

  @override
  DrawerMainState createState() => DrawerMainState();
}

class DrawerMainState extends State<DrawerMain> {
  bool _isAuthenticated = false;

  void checkAuthentication() {
    _isAuthenticated = authManager.isUserAuthenticated();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Підтвердження виходу'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ви впевнені, що хочете вийти з облікового запису?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Скасувати'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Вийти'),
              onPressed: () {
                authManager.logout();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: const Text(
              'Барбершоп',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            selected: widget.selected == 'about',
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text('Про нас', style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          if (!_isAuthenticated)
            ListTile(
              selected: widget.selected == 'registration',
              leading: const Icon(Icons.person_add, color: Colors.blue),
              title: const Text('Реєстрація', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/registration');
              },
            ),
          if (_isAuthenticated)
            ListTile(
              selected: widget.selected == 'profile',
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text('Профіль', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ListTile(
            selected: widget.selected == 'home',
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Домашня сторінка', style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          if (!_isAuthenticated)
            ListTile(
              selected: widget.selected == 'login',
              leading: const Icon(Icons.login, color: Colors.blue),
              title: const Text('Увійти', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          if (_isAuthenticated)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.blue),
              title: const Text('Вийти', style: TextStyle(color: Colors.blue)),
              onTap: () async {
                await _showLogoutDialog(context);
              },
            ),
        ],
      ),
    );
  }
}
