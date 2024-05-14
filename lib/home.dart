import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab1sample2/utils.dart';
import 'package:lab1sample2/widgets/custom_button.dart';
import 'package:lab1sample2/widgets/custom_text.dart';
import 'package:lab1sample2/widgets/user_service_list.dart';
import 'global.dart';
import 'helpers/data_picker.dart';
import 'helpers/message.dart';
import 'internet_status_banner.dart';
import 'models/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  List<Map<String, dynamic>> services = all_services;

  DateTime? appointmentDate;
  Future<List<dynamic>>? userServicesFuture;

  @override
  void initState() {
    super.initState();
    userServicesFuture = storage.getUserServices(authManager.currentUser?.email ?? '');
  }

  void updateServiceSelection(int index, bool? newValue) {
    setState(() {
      services[index]['value'] = newValue ?? false;
    });
  }


  void onDatePicked(DateTime pickedDate) {
    setState(() {
      appointmentDate = pickedDate;
    });
  }

  Future<void> bookAppointment() async {
    if (appointmentDate == null || services.every((s) => !s['value'])) {
      showSnackBar('Please select services and a date.', Colors.red, context);
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
    await storage.createService(newService);
    setState(() {
      appointmentDate = null;
      for (var service in services) {
        service['value'] = false;
      }
      userServicesFuture = storage.getUserServices(authManager.currentUser?.email ?? '');
    });
    showSnackBar('Appointment booked successfully!', Colors.green, context);
  }

  Future<void> deleteAppointment(int id) async {
    await storage.deleteService(id);
    setState(()  {
      userServicesFuture = storage.getUserServices(authManager.currentUser?.email ?? '');
    });
    showSnackBar('Appointment deleted successfully!', Colors.green, context);
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const CustomText(text:"Barbershop"),
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
                const CustomText(text: 'Select Services:'),
                for (int i = 0; i < services.length; i++)
                  CheckboxListTile(
                    title: Text(services[i]['label']),
                    value: services[i]['value'],
                    onChanged: (newValue) => updateServiceSelection(i, newValue),
                    activeColor: Colors.blue,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => pickDate(
                    context: context,
                    onDatePicked: onDatePicked,
                    initialDate: appointmentDate,
                  ),
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
                CustomButton(
                  text: 'Book Appointment',
                  onPressed: bookAppointment,
                ),
                const SizedBox(height: 20),
                const CustomText(text: 'Appointments:',),
                const SizedBox(height: 20),
                UserServicesList(
                  userServicesFuture: userServicesFuture!,
                  deleteAppointment: deleteAppointment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
