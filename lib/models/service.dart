
import 'dart:convert';

class ServiceBarb {
  final int? id;
  final String userEmail;
  final List<String> services;
  final DateTime appointmentDate;

  ServiceBarb({
    this.id,
    required this.userEmail,
    required this.services,
    required this.appointmentDate,
  });

  // Перетворення об'єкта Service у Map для збереження
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'services': services,
      'appointmentDate': appointmentDate.toIso8601String(), // Зберігаємо дату у форматі ISO
    };
  }

  // Відтворення об'єкта Service з Map
  factory ServiceBarb.fromMap(Map<String, dynamic> map) {
    if (map['services'] is String) {
        map['services'] = jsonDecode(map['services']);
    }

    return ServiceBarb(
      id: map['id'],
      userEmail: map['userEmail'] ?? '',
      services:  List<String>.from(map['services'] ?? []),
      appointmentDate: DateTime.parse(map['appointmentDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
