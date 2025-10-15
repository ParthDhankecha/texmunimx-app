// Reusable widget for a date picker field
import 'package:flutter/material.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';

class DateInputField extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  const DateInputField({
    super.key,
    required this.selectedDate,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF9F9FA),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != selectedDate) {
            onDateSelected(pickedDate);
          }
        },
        controller: TextEditingController(
          text: selectedDate == null
              ? 'Select Date'
              : selectedDate!.ddmmyyFormat,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),

          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        ),
      ),
    );
  }
}
