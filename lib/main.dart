import 'package:cinec_movies/firebase_options.dart';
import 'package:cinec_movies/routes.dart';
import 'package:cinec_movies/screens/layout_screen.dart';
import 'package:cinec_movies/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinec Movies',
      theme: AppTheme.lightTheme,
      home: const LayoutScreen(pageIndex: 0),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
