import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:gap/gap.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'More Screen'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Center(
          child: Column(
            children: [
              Text('More Screen'),
              Gap(16),
              PrimaryButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                text: 'LogOut',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
