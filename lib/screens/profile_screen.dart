import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/custom_alert.dart';
import 'package:cinec_movies/widgets/image_icon_builder.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // // Profile picture
                CircleAvatar(
                  radius: 50,

                  // backgroundColor: Colors.grey.shade300,
                  child: ImageIconBuilder(
                    image: 'assets/icons/user.png',
                    iconColor: AppColors.gray900,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Email
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),

                // Details card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Phone',
                          user.phone.isEmpty ? 'N/A' : user.phone,
                        ),
                        _buildDetailRow(
                          'Role',
                          state.isAdmin ? 'Admin' : 'User',
                        ),
                        _buildDetailRow(
                          'Joined',
                          CoreUtils.formatDate(user.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Edit profile button
                PrimaryButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-profile',
                      arguments: {'user': state.user},
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Logout button
                PrimaryButton(
                  text: 'Logout',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlert(
                          iconPath: 'assets/icons/logout.png',
                          title: 'Logout',
                          message:
                              'Are you sure you want to logout of your account?',
                          onConfirm: () => _logout(context),
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
