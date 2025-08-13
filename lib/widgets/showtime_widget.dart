import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowtimeWidget extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback? onTap;

  const ShowtimeWidget({super.key, required this.dateTime, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          '${DateFormat('yyyy-MM-dd').format(dateTime)} at '
          '${DateFormat('hh:mm a').format(dateTime)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
