import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/custom_alert.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/select_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final googleSignIn = GoogleSignIn.instance;

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      Navigator.pushNamedAndRemoveUntil(
        rootNavigatorKey.currentContext!,
        '/login',
        (route) => false,
      );
    } catch (e) {
      CoreUtils.toastError('Failed to log out: $e');
    }
  }

  void addDummyMovies() async {
    final firestore = FirebaseFirestore.instance;
    final movies = [
      {
        "title": "Inception",
        "genre": "Sci-Fi",
        "duration": 148,
        "synopsis":
            "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.",
        "posterUrl":
            "https://firebasestorage.googleapis.com/v0/b/cinec-movie-booking.firebasestorage.app/o/MoviePosters%2Finception.jpg?alt=media&token=5547f6db-92f1-4428-9720-4712a75a9c0e",
        "createdAt": DateTime.now().toIso8601String(),
        "showtimes": [
          {"date": "2025-08-12", "time": "18:00"},
          {"date": "2025-08-12", "time": "21:00"},
          {"date": "2025-08-13", "time": "15:00"},
        ],
      },
      {
        "title": "The Dark Knight",
        "genre": "Action",
        "duration": 152,
        "synopsis":
            "Batman faces the Joker, a criminal mastermind who wants to plunge Gotham into chaos.",
        "posterUrl":
            "https://firebasestorage.googleapis.com/v0/b/cinec-movie-booking.firebasestorage.app/o/MoviePosters%2Fthe%20dark%20knight.jpg?alt=media&token=55846c13-0736-45bb-8cc6-4cee3c213d40",
        "createdAt": DateTime.now().toIso8601String(),
        "showtimes": [
          {"date": "2025-08-12", "time": "17:00"},
          {"date": "2025-08-13", "time": "20:00"},
        ],
      },
      {
        "title": "Interstellar",
        "genre": "Adventure",
        "duration": 169,
        "synopsis":
            "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
        "posterUrl":
            "https://firebasestorage.googleapis.com/v0/b/cinec-movie-booking.firebasestorage.app/o/MoviePosters%2Finterstellar.jpg?alt=media&token=19e2fa33-f187-4775-857b-66793bdf1ed0",
        "createdAt": DateTime.now().toIso8601String(),
        "showtimes": [
          {"date": "2025-08-14", "time": "14:00"},
          {"date": "2025-08-14", "time": "19:00"},
        ],
      },
    ];

    for (var movie in movies) {
      final movieData = Map<String, dynamic>.from(movie);
      final showtimes = movieData.remove('showtimes') as List<dynamic>;

      // Add movie doc without showtimes
      final movieRef = await firestore.collection('movies').add(movieData);

      // Add showtimes subcollection
      for (var showtime in showtimes) {
        await movieRef.collection('showtimes').add({
          "date": showtime['date'],
          "time": showtime['time'],
          "bookedSeats": <String>[],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: Wrap(
            runSpacing: 8,
            children: [
              SelectCard(
                title: 'My Profile',
                icon: 'assets/icons/user.png',
                onTap: addDummyMovies,
                isBordered: true,
              ),

              PrimaryButton(
                text: 'Settings',
                onPressed: () {
                  CoreUtils.showBottomSheet(
                    Column(children: [Text('Settings Bottom Sheet')]),
                  );
                },
              ),

              SelectCard(
                title: 'Log Out',
                icon: 'assets/icons/logout.png',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        iconPath: 'assets/icons/logout.png',
                        title: 'Logout',
                        message:
                            'Are you sure you want to Logout of your account?',
                        onConfirm: () => _logout(context),
                      );
                    },
                  );
                },
                isBordered: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
