class MovieModel {
  final String id;
  final String title;
  final String genre;
  final int duration; // in minutes
  final String synopsis;
  final String posterUrl;
  final DateTime createdAt;
  final bool nowShowing;

  MovieModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.synopsis,
    required this.posterUrl,
    required this.createdAt,
    required this.nowShowing,
  });

  factory MovieModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return MovieModel(
      id: docId,
      title: data['title'] ?? '',
      genre: data['genre'] ?? '',
      duration: data['duration'] ?? 0,
      synopsis: data['synopsis'] ?? '',
      posterUrl: data['posterUrl'] ?? '',
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      nowShowing: data['nowShowing'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'duration': duration,
      'synopsis': synopsis,
      'posterUrl': posterUrl,
      'createdAt': createdAt.toIso8601String(),
      'nowShowing': nowShowing,
    };
  }
}
