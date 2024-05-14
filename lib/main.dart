import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1sample2/widgets/drawer.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/appointment_cubit.dart';
import 'home.dart';
import 'login.dart';
import 'prof.dart';
import 'reg.dart';
import 'internet_status_banner.dart';
import 'models/user.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? curUser = await storage.getCurrentUser();
  if (curUser != null) {
    authManager.login(curUser.email, curUser.password);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => AppointmentCubit()),
      ],
      child: MaterialApp(
        title: 'Барбершоп',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(),
          '/registration': (context) => Reg(),
          '/profile': (context) => const Prof(),
          '/home': (context) => const Home(),
          '/login': (context) => const Login(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Про нас', style: TextStyle(color: Colors.blue)),
          backgroundColor: Colors.grey[200],
        ),
        body: const Center(
          child: Text(
            'Барбершоп',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: DrawerMain(selected: 'about'),
      ),
    );
  }
}

