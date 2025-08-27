import 'package:flutter/material.dart';
import 'package:flutterproject/utils/my_button.dart';
import 'package:intl/intl.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime) onSave;
  final VoidCallback onCancel;
  final DateTime? initialDateTime;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.initialDateTime,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _errorText;

  // pick date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
  @override
  void initState() {
    super.initState();

    if (widget.initialDateTime != null) {
      selectedDate = widget.initialDateTime;
      selectedTime = TimeOfDay(
        hour: widget.initialDateTime!.hour,
        minute: widget.initialDateTime!.minute,
      );
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void emptyTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("⚠️ Task name cannot be empty!"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    String taskName;

    // formatted date
    String dateText = selectedDate == null
        ? "No date"
        : DateFormat('EEE, d MMM yyyy').format(selectedDate!);

    // formatted time
    String timeText = selectedTime == null
        ? "No time"
        : selectedTime!.format(context);

    return AlertDialog(
      backgroundColor: Colors.cyan,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Task name input
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Add a new task",
              errorText: _errorText,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateText),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text("Pick Date"),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(timeText),
              ElevatedButton(
                onPressed: _pickTime,
                child: Text("Pick Time"),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyButton(
                text: "Save",
                onPressed: () {
                  taskName = widget.controller.text;

                  if (taskName.trim().isEmpty) {
                    setState(() {
                      _errorText = "Task name cannot be empty";
                    });
                    return;
                  }

                  DateTime baseDate = selectedDate ?? DateTime.now();

                  TimeOfDay time = selectedTime ?? TimeOfDay.now();

                  DateTime finalDateTime = DateTime(
                    baseDate.year,
                    baseDate.month,
                    baseDate.day,
                    time.hour,
                    time.minute,
                  );

                  widget.onSave(finalDateTime);
                },
              ),
              MyButton(text: "Cancel", onPressed: widget.onCancel),
            ],
          ),
        ],
      ),
    );
  }
}
