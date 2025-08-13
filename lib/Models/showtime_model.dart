import 'package:cloud_firestore/cloud_firestore.dart';

class ShowtimeModel {
  final String id;
  final DateTime dateTime;
  final List<String> bookedSeats;

  ShowtimeModel({
    required this.id,
    required this.dateTime,
    required this.bookedSeats,
  });

  factory ShowtimeModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ShowtimeModel(
      id: docId,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      bookedSeats: List<String>.from(data['bookedSeats'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': Timestamp.fromDate(dateTime),
      'bookedSeats': bookedSeats,
    };
  }
}
