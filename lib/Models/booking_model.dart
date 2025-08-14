class BookingModel {
  final String id;
  final String movieId;
  final String movieTitle;
  final String posterUrl;
  final DateTime showDateTime;
  final List<String> seats;
  final DateTime bookedAt;

  BookingModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.showDateTime,
    required this.seats,
    required this.bookedAt,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BookingModel(
      id: docId,
      movieId: data['movieId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      posterUrl: data['posterUrl'] ?? '',
      showDateTime:
          DateTime.tryParse(data['showDateTime'] ?? '') ?? DateTime.now(),
      seats: List<String>.from(data['seats'] ?? []),
      bookedAt: DateTime.tryParse(data['bookedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterUrl': posterUrl,
      'showDateTime': showDateTime.toIso8601String(),
      'seats': seats,
      'bookedAt': bookedAt.toIso8601String(),
    };
  }
}
