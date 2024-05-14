import '../models/service.dart';
import '../models/user.dart';
import 'api_user_storage.dart';
import 'i_user_storage.dart';
import 'local_user_storage.dart';

class CompositeUserStorage implements IUserStorage {
  final APIUserStorage apiStorage;
  final LocalUserStorage localStorage;

  CompositeUserStorage(String baseUrl)
      : apiStorage = APIUserStorage(baseUrl),
        localStorage = LocalUserStorage();

  @override
  Future<void> saveUser(User user) async {
    await apiStorage.saveUser(user);
    await localStorage.saveUser(user);
  }

  @override
  Future<User?> getUser(String email) async {
    User? user = await apiStorage.getUser(email);
    if (user != null) {
      await localStorage.saveUser(user);
      return user;
    }
    return await localStorage.getUser(email);
  }

  @override
  Future<void> clearUser(String email) async {
    await apiStorage.clearUser(email);
    await localStorage.clearUser(email);
  }

  @override
  Future<void> saveCurrentUser(String email) async {
    await localStorage.saveCurrentUser(email);
  }

  @override
  Future<void> clearCurrentUser() async {
    await localStorage.clearCurrentUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    User? user = await localStorage.getCurrentUser();
    if (user != null) {
      user = await getUser(user.email);
    }
    return user;
  }

  Future<void> createService(ServiceBarb service) async {
    await apiStorage.createService(service);
    await localStorage.createService(service);
  }

  Future<List<dynamic>> getUserServices(String email) async {
    List<dynamic> services = await apiStorage.getUserServices(email);
    if (services.isNotEmpty) {
      return services;
    }
    return await localStorage.getUserServices(email);
  }

  Future<void> deleteService(int serviceId) async {
    await apiStorage.deleteService(serviceId);
    await localStorage.deleteService(serviceId);
  }
}
