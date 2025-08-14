import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShowtimeWidget extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback? onTap;
  final bool isLoading;

  const ShowtimeWidget({
    super.key,
    required this.dateTime,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${DateFormat('yyyy-MM-dd').format(dateTime)} at '
                    '${DateFormat('hh:mm a').format(dateTime)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
