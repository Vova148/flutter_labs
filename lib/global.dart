

import 'package:lab1sample2/storage/auth_manager.dart';
import 'package:lab1sample2/storage/secure_user_storage.dart';

final SecureUserStorage storage = SecureUserStorage();
final AuthManager authManager = AuthManager(SecureUserStorage());

