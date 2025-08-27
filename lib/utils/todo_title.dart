import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoTitle extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final DateTime? time;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext?)? onEdit;

  const TodoTitle({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    this.time,
    this.onChanged,
    this.deleteFunction,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    String dateText = time == null
        ? ""
        : DateFormat('EEE, d MMM yyyy – HH:mm').format(time!);

    return Card(
      color: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
      title: Text(
        taskName,
      ),
      subtitle: Text("📅 ${dateText}"),
      leading: Checkbox(
        value: taskCompleted,
        onChanged: onChanged,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // important to keep Row compact
        children: [
          if (onEdit != null)
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () => onEdit!(context),
            ),
          if (deleteFunction != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteFunction!(context),
          ),
        ],
      ),
      ),
    );
  }
}
