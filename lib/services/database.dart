import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Stream<QuerySnapshot> getAllMovies({required bool isAdmin}) {
    final collection = FirebaseFirestore.instance.collection("movies");

    if (isAdmin) {
      return collection.orderBy('createdAt', descending: true).snapshots();
    } else {
      return collection
          .where('nowShowing', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getMovieById(String id) {
    return FirebaseFirestore.instance.collection("movies").doc(id).snapshots();
  }

  Stream<QuerySnapshot> getShowtimesByMovieId(String movieId) {
    final now = DateTime.now();

    return FirebaseFirestore.instance
        .collection("movies")
        .doc(movieId)
        .collection("showtimes")
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy("dateTime")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getShowtimeByMovieAndId(
    String movieId,
    String showtimeId,
  ) {
    return FirebaseFirestore.instance
        .collection("movies")
        .doc(movieId)
        .collection("showtimes")
        .doc(showtimeId)
        .snapshots();
  }

  Future<void> updateMovieStatusById(String id, bool nowShowing) async {
    return await FirebaseFirestore.instance.collection("movies").doc(id).update(
      {'nowShowing': nowShowing},
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
  }

  Stream<QuerySnapshot> getAllBookings({
    required bool isAdmin,
    required String userId,
  }) {
    final collection = FirebaseFirestore.instance.collection("bookings");

    if (isAdmin) {
      return collection.orderBy('bookedAt', descending: true).snapshots();
    } else {
      return collection
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .snapshots();
    }
  }
}
