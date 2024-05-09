
class ServiceBarb {
  final String userEmail;
  final List<String> services;
  final DateTime appointmentDate;

  ServiceBarb({
    required this.userEmail,
    required this.services,
    required this.appointmentDate,
  });

  // Перетворення об'єкта Service у Map для збереження
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'services': services,
      'appointmentDate': appointmentDate.toIso8601String(), // Зберігаємо дату у форматі ISO
    };
  }

  // Відтворення об'єкта Service з Map
  factory ServiceBarb.fromMap(Map<String, dynamic> map) {
    return ServiceBarb(
      userEmail: map['userEmail'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      appointmentDate: DateTime.parse(map['appointmentDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
