import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lab1sample2/global.dart';
import 'package:lab1sample2/helpers/message.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final String? message;

  AuthState({required this.status, this.message});

  AuthState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(status: AuthStatus.initial)) {
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    if (authManager.isUserAuthenticated()) {
      emit(state.copyWith(status: AuthStatus.authenticated));
    }
  }

  Future<void> login(String email, String password, BuildContext context) async {
    emit(state.copyWith(status: AuthStatus.loading));

    bool isInternetAvailable = await _isInternetAvailable();
    if (!isInternetAvailable) {
      emit(state.copyWith(
        status: AuthStatus.error,
        message: 'No Internet Connection',
      ));
      _showNoInternetDialog(context);
      return;
    }

    bool success = await authManager.login(email, password);
    if (success) {
      storage.saveCurrentUser(email);
      emit(state.copyWith(status: AuthStatus.authenticated));
      showSnackBar('Login successful!', Colors.green, context);
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        message: 'Login failed! Invalid email or password.',
      ));
      showSnackBar(state.message!, Colors.red, context);
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
}
