import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> pickDate({
  required BuildContext context,
  required Function(DateTime) onDatePicked,
  required DateTime? initialDate,
}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 1),
  );

  if (pickedDate != null && pickedDate != initialDate) {
    onDatePicked(pickedDate);
  }
}