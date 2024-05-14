import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lab1sample2/utils.dart';
import 'package:lab1sample2/widgets/custom_button.dart';
import 'package:lab1sample2/widgets/custom_text.dart';
import 'package:lab1sample2/widgets/user_service_list.dart';
import 'cubits/appointment_cubit.dart';
import 'global.dart';
import 'helpers/data_picker.dart';
import 'internet_status_banner.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkAwareWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const CustomText(text: "Barbershop"),
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
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        for (int i = 0; i < state.services.length; i++)
                          CheckboxListTile(
                            title: Text(state.services[i]['label']),
                            value: state.services[i]['value'],
                            onChanged: (newValue) {
                              context.read<AppointmentCubit>().updateServiceSelection(i, newValue);
                            },
                            activeColor: Colors.blue,
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () => pickDate(
                        context: context,
                        onDatePicked: (pickedDate) => context.read<AppointmentCubit>().onDatePicked(pickedDate),
                        initialDate: state.appointmentDate,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        state.appointmentDate == null
                            ? 'Pick Appointment Date'
                            : DateFormat('dd-MM-yyyy').format(state.appointmentDate!),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Book Appointment',
                  onPressed: () => context.read<AppointmentCubit>().bookAppointment(context),
                ),
                const SizedBox(height: 20),
                const CustomText(text: 'Appointments:'),
                const SizedBox(height: 20),
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return UserServicesList(
                      userServicesFuture: state.userServicesFuture!,
                      deleteAppointment: (id) => context.read<AppointmentCubit>().deleteAppointment(context, id),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
