import 'package:lab1sample2/models/service.dart';

class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final List<ServiceBarb> selectedServices;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.selectedServices = const [], // Default to an empty list if not provided
  });

  // Convert User object to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password, // The password should ideally be hashed for security
      'selectedServices': selectedServices.map((s) => s.toMap()).toList(), // Serialize list of services
    };
  }
  void addService(ServiceBarb service) {
    selectedServices.add(service);
  }
  // Reconstruct User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      selectedServices: (map['selectedServices'] as List<dynamic>?)
          ?.map((s) => ServiceBarb.fromMap(s))
          .toList() ?? [], // Deserialize list of services
    );
  }
}
