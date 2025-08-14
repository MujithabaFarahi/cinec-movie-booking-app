import 'package:cinec_movies/screens/add_movie_screen.dart';
import 'package:cinec_movies/screens/add_showtime_screen.dart';
import 'package:cinec_movies/screens/edit_profile_screen.dart';
import 'package:cinec_movies/screens/layout_screen.dart';
import 'package:cinec_movies/screens/movie_view_screen.dart';
import 'package:cinec_movies/screens/seat_selection_screen.dart';
import 'package:cinec_movies/screens/sign_in_screen.dart';
import 'package:cinec_movies/screens/sign_up_screen.dart';
import 'package:cinec_movies/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/home':
        return _createRoute(const LayoutScreen(pageIndex: 0));

      case '/bookings':
        return _createRoute(const LayoutScreen(pageIndex: 1));

      case '/profile':
        return _createRoute(const LayoutScreen(pageIndex: 2));

      case '/movie':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(MovieViewScreen(movie: args?['movie']));

      case '/edit-profile':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(EditProfileScreen(user: args?['user']));

      case '/add-showtime':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(AddShowtimeScreen(movieId: args?['movieId']));

      case '/add-movie':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          AddMovieScreen(isEditMode: args?['isEditMode'] ?? false),
        );

      case '/seat-selection':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _createRoute(
          SeatSelectionScreen(
            showTimeId: args?['showTimeId'],
            movieId: args?['movieId'],
            ticketCount: args?['ticketCount'],
            ticketPrice: args?['ticketPrice'],
          ),
        );

      case '/login':
        return _createRoute(const SignInScreen());

      case '/register':
        return _createRoute(const SignUpScreen());

      default:
        return _createRoute(const SplashScreen());
    }
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.2, 0.0); // Slide from the right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final slideTween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(slideTween);

      final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      final fadeAnimation = animation.drive(fadeTween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: fadeAnimation, child: child),
      );
    },
  );
}
