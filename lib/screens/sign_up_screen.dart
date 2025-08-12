import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/theme_extension.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/utils/validators.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:cinec_movies/widgets/social_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': _nameController.text.trim(),
        'phone': _mobileController.text.trim(),
        'lastLogin': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      print(e);
      CoreUtils.toastError("Registration failed: $e");
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await _navigateToHome(userCredential.user!);
    } catch (e) {
      CoreUtils.toastError("Google Sign-In failed: $e");
    }
  }

  Future<void> _navigateToHome(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'id': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'phone': user.phoneNumber ?? '',
        'lastLogin': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });
    } else {
      await userDoc.update({'lastLogin': DateTime.now().toIso8601String()});
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // -------- Top content --------
                          Text(
                            'Create a New Account',
                            style: context.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(12),
                          Text(
                            'Book tickets for your favorite movie shows in one place.',
                            style: context.titleMedium.copyWith(
                              color: AppColors.gray700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // -------- Pushes below section to the bottom --------
                          const Gap(40),
                          // -------- Bottom social buttons + terms --------
                          PrimaryTextfield(
                            labelText: "Name",
                            hintText: "Enter name",
                            keyboardType: TextInputType.name,
                            validator: Validators.name,
                            controller: _nameController,
                          ),
                          const Gap(16),
                          PrimaryTextfield(
                            labelText: "Email",
                            hintText: "Enter email",
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            controller: _emailController,
                          ),
                          const Gap(16),
                          PrimaryTextfield(
                            labelText: "Mobile Number",
                            hintText: "+94 77 123 4567",
                            keyboardType: TextInputType.phone,
                            validator: Validators.mobileNumber,
                            controller: _mobileController,
                          ),
                          const Gap(16),
                          PrimaryTextfield(
                            labelText: "Password",
                            hintText: "Enter password",
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: Validators.password,
                            controller: _passwordController,
                          ),

                          const Gap(32),

                          PrimaryButton(
                            text: 'Create Account',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _registerWithEmailPassword();
                              }
                            },
                          ),
                          const Gap(32),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: context.titleMedium.copyWith(
                                  color: AppColors.gunmetal600,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Log In",
                                    style: context.titleMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SocialDivider(),
                          PrimaryButton(
                            text: 'Continue with Google',
                            onPressed: _loginWithGoogle,
                            svgIconPath: 'assets/icons/google.svg',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
