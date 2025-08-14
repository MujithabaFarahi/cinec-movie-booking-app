import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/custom_alert.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout(BuildContext context) async {
    final googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      rootNavigatorKey.currentContext!.read<MovieBloc>().add(
        const ResetState(),
      );

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
  void initState() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      BlocProvider.of<MovieBloc>(context).add(GetUserById(userId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user!;

          return Stack(
            children: [
              // Background header gradient
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue500, AppColors.alizarin500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Profile Content
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // Profile Picture
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/icons/user.png'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Name & Email
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.peach100,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pureBlack.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Phone',
                            user.phone.isEmpty ? 'N/A' : user.phone,
                          ),
                          const Divider(),
                          _buildDetailRow(
                            'Role',
                            state.isAdmin ? 'Admin' : 'User',
                          ),
                          const Divider(),
                          _buildDetailRow(
                            'Joined',
                            CoreUtils.formatDate(user.createdAt),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
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
                          PrimaryButton(
                            text: 'Logout',
                            // icon: 'assets/icons/logout.png',
                            svgIconPath: 'assets/icons/logout.svg',
                            backgroundColor: AppColors.alizarin500,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
