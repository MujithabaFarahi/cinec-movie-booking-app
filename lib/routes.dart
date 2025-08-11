import 'package:cinec_movies/screens/layout_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/home':
        return _createRoute(const LayoutScreen(pageIndex: 0));

      case '/item':
        return _createRoute(const LayoutScreen(pageIndex: 1));

      case '/add':
        return _createRoute(const LayoutScreen(pageIndex: 2));

      case '/more':
        return _createRoute(const LayoutScreen(pageIndex: 3));

      default:
        return _createRoute(const LayoutScreen(pageIndex: 0));
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
