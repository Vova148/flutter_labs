import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserServicesList extends StatelessWidget {
  final Future<List<dynamic>> userServicesFuture;
  final Function(int) deleteAppointment;

  const UserServicesList({
    Key? key,
    required this.userServicesFuture,
    required this.deleteAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: userServicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text(
            'Error loading services',
            style: TextStyle(color: Colors.red),
          );
        } else {
          final userServices = snapshot.data ?? [];
          return Expanded(
            child: ListView.builder(
              itemCount: userServices.length,
              itemBuilder: (context, index) {
                final service = userServices[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      '${DateFormat('dd-MM-yyyy').format(service.appointmentDate)}: ${service.services.join(', ')}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteAppointment(service.id),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
