import 'package:cloud_firestore/cloud_firestore.dart';

class ShowtimeModel {
  final String id;
  final DateTime dateTime;
  final List<String> bookedSeats;
  final double ticketPrice;
  ShowtimeModel({
    required this.id,
    required this.dateTime,
    required this.bookedSeats,
    required this.ticketPrice,
  });

  factory ShowtimeModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ShowtimeModel(
      id: docId,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      bookedSeats: List<String>.from(data['bookedSeats'] ?? []),
      ticketPrice: (data['ticketPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': Timestamp.fromDate(dateTime),
      'bookedSeats': bookedSeats,
      'ticketPrice': ticketPrice,
    };
  }
}
