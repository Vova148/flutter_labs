

import 'package:lab1sample2/storage/auth_manager.dart';
import 'package:lab1sample2/storage/composite_user_storage.dart';
import 'package:lab1sample2/storage/secure_user_storage.dart';

final CompositeUserStorage storage = CompositeUserStorage("http://127.0.0.1:8000");
final AuthManager authManager = AuthManager(CompositeUserStorage("http://127.0.0.1:8000"));
final all_services =  [
  {'label': 'Haircuts', 'value': false},
  {'label': 'Shaving', 'value': false},
  {'label': 'Beard trimming', 'value': false},
  {'label': 'Styling', 'value': false},
];

