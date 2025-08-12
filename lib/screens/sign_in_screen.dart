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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _navigateToHome(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      CoreUtils.toastError(e.code, title: 'Login Failed');
    } catch (e) {
      CoreUtils.toastError(" $e", title: 'Login failed');
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '1061970085110-gj0kvt0ecs80ef1fdgb6hlpgld9mfq2s.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await _navigateToHome(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      CoreUtils.toastError(e.code, title: 'Login Failed');
    } on GoogleSignInException catch (e) {
      CoreUtils.toastError(
        e.description ?? 'Unknown error',
        title: 'Google Sign-In failed',
      );
    } catch (e) {
      CoreUtils.toastError(" ${e.toString()}", title: 'Google Sign-In failed');
    }
  }

  Future<void> _navigateToHome(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'id': user.uid,
        'email': user.email ?? '',
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
                          // ---------- Top content ----------
                          Text(
                            'Log In',
                            style: context.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(16),
                          Text(
                            'Book tickets for your favorite movies now.',
                            style: context.titleMedium.copyWith(
                              color: AppColors.gray700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // ---------- Spacer pushes the bottom buttons ----------
                          const Gap(40),
                          // ---------- Bottom content ----------
                          PrimaryTextfield(
                            labelText: "Email",
                            hintText: "Enter email",
                            // textInputType: TextInputType.emailAddress,
                            validator: Validators.email,
                            controller: _emailController,
                          ),
                          const Gap(16),
                          PrimaryTextfield(
                            labelText: "Password",
                            hintText: "Enter password",
                            // textInputType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: Validators.password,
                            controller: _passwordController,
                          ),
                          const Gap(6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password',
                              style: context.titleMedium.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Gap(32),
                          PrimaryButton(
                            text: 'Log In',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _loginWithEmailPassword();
                              }
                            },
                          ),
                          const Gap(32),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: context.titleMedium.copyWith(
                                  color: AppColors.gunmetal600,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Create an account",
                                    style: context.titleMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/register',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SocialDivider(),
                          Wrap(
                            runSpacing: 16,
                            children: [
                              PrimaryButton(
                                text: 'Continue with Google',
                                onPressed: () {
                                  _loginWithGoogle();
                                },
                                svgIconPath: 'assets/icons/google.svg',
                              ),
                            ],
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
