import 'package:cinec_movies/Models/showtime_model.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddShowtimeScreen extends StatefulWidget {
  final String movieId;

  const AddShowtimeScreen({super.key, required this.movieId});

  @override
  State<AddShowtimeScreen> createState() => _AddShowtimeScreenState();
}

class _AddShowtimeScreenState extends State<AddShowtimeScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 18, minute: 0);
  final TextEditingController priceController = TextEditingController(
    text: '400',
  );

  bool isLoading = false;

  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _saveShowtime() async {
    if (priceController.text.isEmpty) {
      CoreUtils.toastError("Please enter a price");
      return;
    }

    final double? ticketPrice = double.tryParse(priceController.text);
    if (ticketPrice == null || ticketPrice <= 0) {
      CoreUtils.toastError("Please enter a valid ticket price");
      return;
    }

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() => isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection('movies')
          .doc(widget.movieId)
          .collection('showtimes')
          .doc();

      final showtime = ShowtimeModel(
        id: docRef.id,
        dateTime: dateTime,
        bookedSeats: [],
        ticketPrice: ticketPrice,
      );

      await docRef.set(showtime.toMap());

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      CoreUtils.toastError("Failed to add showtime: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add Showtime', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _pickDate,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),

            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _pickTime,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedTime.format(context)),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            PrimaryTextfield(
              controller: priceController,
              keyboardType: TextInputType.number,
              labelText: 'Ticket Price',
              hintText: 'Enter ticket price',
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Save Showtime",
              onPressed: isLoading ? () {} : _saveShowtime,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
