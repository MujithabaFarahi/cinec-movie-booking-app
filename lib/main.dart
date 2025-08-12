import 'package:cinec_movies/blocs/auth/auth_bloc.dart';
import 'package:cinec_movies/firebase_options.dart';
import 'package:cinec_movies/routes.dart';
import 'package:cinec_movies/screens/splash_screen.dart';
import 'package:cinec_movies/services/database.dart';
import 'package:cinec_movies/theme/app_theme.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final DatabaseMethods databaseMethods = DatabaseMethods();

  runApp(MyApp(databaseMethods: databaseMethods));
}

class MyApp extends StatefulWidget {
  final DatabaseMethods databaseMethods;
  const MyApp({super.key, required this.databaseMethods});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(widget.databaseMethods)),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: rootNavigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Cinec Movies',
          theme: AppTheme.lightTheme,
          home: SplashScreen(),
          onGenerateRoute: _appRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
