class BookingModel {
  final String id;
  final String movieId;
  final String movieTitle;
  final String posterUrl;
  final String date;
  final String time;
  final List<String> seats;
  final DateTime bookedAt;

  BookingModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.date,
    required this.time,
    required this.seats,
    required this.bookedAt,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BookingModel(
      id: docId,
      movieId: data['movieId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      posterUrl: data['posterUrl'] ?? '',
      date: data['showtime']?['date'] ?? '',
      time: data['showtime']?['time'] ?? '',
      seats: List<String>.from(data['seats'] ?? []),
      bookedAt: DateTime.tryParse(data['bookedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterUrl': posterUrl,
      'showtime': {'date': date, 'time': time},
      'seats': seats,
      'bookedAt': bookedAt.toIso8601String(),
    };
  }
}
