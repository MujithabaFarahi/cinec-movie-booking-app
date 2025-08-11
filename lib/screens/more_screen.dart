import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/appbar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'More Screen'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Center(child: Text('More Screen')),
      ),
    );
  }
}
