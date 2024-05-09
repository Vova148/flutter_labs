import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'global.dart';
import 'models/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<Map<String, dynamic>> services = [
    {'label': 'Haircuts', 'value': false},
    {'label': 'Shaving', 'value': false},
    {'label': 'Beard trimming', 'value': false},
    {'label': 'Styling', 'value': false},
  ];

  DateTime? appointmentDate;

  void updateServiceSelection(int index, bool? newValue) {
    setState(() {
      services[index]['value'] = newValue ?? false;
    });
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != appointmentDate) {
      setState(() {
        appointmentDate = pickedDate;
      });
    }
  }

  void bookAppointment() {
    if (appointmentDate == null || services.every((s) => !s['value'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select services and a date.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final List<String> bookedServices = services
        .where((service) => service['value'] == true)
        .map((service) => service['label'].toString())
        .toList();

    final ServiceBarb newService = ServiceBarb(
      userEmail: authManager.currentUser?.email ?? '',
      services: bookedServices,
      appointmentDate: appointmentDate!,
    );

    setState(() {
      authManager.currentUser?.selectedServices.add(newService);
      storage.saveUser(authManager.currentUser!);
      appointmentDate = null;
      for (var service in services) {
        service['value'] = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment booked successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void deleteAppointment(int index) {
    setState(() {
      authManager.currentUser?.selectedServices.removeAt(index);
      storage.saveUser(authManager.currentUser!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment deleted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userServices = authManager.currentUser?.selectedServices ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Barbershop',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Services:',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              for (int i = 0; i < services.length; i++)
                CheckboxListTile(
                  title: Text(services[i]['label']),
                  value: services[i]['value'],
                  onChanged: (newValue) => updateServiceSelection(i, newValue),
                  activeColor: Colors.blue,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  appointmentDate == null
                      ? 'Pick Appointment Date'
                      : DateFormat('dd-MM-yyyy').format(appointmentDate!),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Appointments:',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
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
                          onPressed: () => deleteAppointment(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
