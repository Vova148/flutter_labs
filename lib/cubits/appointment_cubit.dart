import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lab1sample2/models/service.dart';
import 'package:lab1sample2/global.dart';
import 'package:lab1sample2/helpers/message.dart';

class AppointmentState {
  final List<Map<String, dynamic>> services;
  final DateTime? appointmentDate;
  final Future<List<dynamic>>? userServicesFuture;

  AppointmentState({
    required this.services,
    this.appointmentDate,
    this.userServicesFuture,
  });

  AppointmentState copyWith({
    List<Map<String, dynamic>>? services,
    DateTime? appointmentDate,
    Future<List<dynamic>>? userServicesFuture,
  }) {
    return AppointmentState(
      services: services ?? this.services,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      userServicesFuture: userServicesFuture ?? this.userServicesFuture,
    );
  }
}

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit()
      : super(AppointmentState(
    services: all_services,
    userServicesFuture: storage.getUserServices(authManager.currentUser?.email ?? ''),
  ));

  void updateServiceSelection(int index, bool? newValue) {
    final updatedServices = List<Map<String, dynamic>>.from(state.services);
    updatedServices[index]['value'] = newValue ?? false;
    emit(state.copyWith(services: updatedServices));
  }

  void onDatePicked(DateTime pickedDate) {
    emit(state.copyWith(appointmentDate: pickedDate));
  }

  Future<void> bookAppointment(BuildContext context) async {
    if (state.appointmentDate == null || state.services.every((s) => !s['value'])) {
      showSnackBar('Please select services and a date.', Colors.red, context);
      return;
    }

    final List<String> bookedServices = state.services
        .where((service) => service['value'] == true)
        .map((service) => service['label'].toString())
        .toList();

    final ServiceBarb newService = ServiceBarb(
      userEmail: authManager.currentUser?.email ?? '',
      services: bookedServices,
      appointmentDate: state.appointmentDate!,
    );
    await storage.createService(newService);

    final resetServices = state.services.map((service) {
      return {'label': service['label'], 'value': false};
    }).toList();

    emit(state.copyWith(
      appointmentDate: null,
      services: resetServices,
      userServicesFuture: storage.getUserServices(authManager.currentUser?.email ?? ''),
    ));
    showSnackBar('Appointment booked successfully!', Colors.green, context);
  }

  Future<void> deleteAppointment(BuildContext context, int id) async {
    await storage.deleteService(id);
    emit(state.copyWith(
      userServicesFuture: storage.getUserServices(authManager.currentUser?.email ?? ''),
    ));
    showSnackBar('Appointment deleted successfully!', Colors.green, context);
  }
}
