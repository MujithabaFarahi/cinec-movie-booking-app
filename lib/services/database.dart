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

  Stream<QuerySnapshot> getAllMovies() {
    return FirebaseFirestore.instance
        .collection("movies")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getMovieById(String id) {
    return FirebaseFirestore.instance
        .collection("movies")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getShowtimesByMovieId(String movieId) {
    final now = DateTime.now();

    return FirebaseFirestore.instance
        .collection("movies")
        .doc(movieId)
        .collection("showtimes")
        .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy("dateTime")
        .snapshots(includeMetadataChanges: true);
  }

  Future updateItem(Map<String, dynamic> updatedData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .update(updatedData);
  }

  Future addOrder(Map<String, dynamic> orderInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .set(orderInfoMap);
  }

  Stream<QuerySnapshot> getAllOrders() {
    return FirebaseFirestore.instance
        .collection("Orders")
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderById(String id) {
    return FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getAllUsers() {
    return FirebaseFirestore.instance
        .collection("users")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Future addReturn(Map<String, dynamic> returnInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .set(returnInfoMap);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getReturnById(String id) {
    return FirebaseFirestore.instance
        .collection("Returns")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getAllReturns() {
    return FirebaseFirestore.instance
        .collection("Returns")
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getAllBuyings() {
    return FirebaseFirestore.instance
        .collection("Buyings")
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getBuyingById(String id) {
    return FirebaseFirestore.instance
        .collection("Buyings")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }
}
