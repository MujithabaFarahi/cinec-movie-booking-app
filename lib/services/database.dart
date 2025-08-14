import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addItem(Map<String, dynamic> itemInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .set(itemInfoMap);
  }

  Future<bool> isNameUnique(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Bags")
        .where("name", isEqualTo: name)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Stream<QuerySnapshot> getAllMovies({required bool isAdmin}) {
    final collection = FirebaseFirestore.instance.collection("movies");

    if (isAdmin) {
      return collection.snapshots();
    } else {
      return collection.where('nowShowing', isEqualTo: true).snapshots();
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

  Future updateItem(Map<String, dynamic> updatedData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .update(updatedData);
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
      return collection.snapshots();
    } else {
      return collection.where('userId', isEqualTo: userId).snapshots();
    }
  }
}
