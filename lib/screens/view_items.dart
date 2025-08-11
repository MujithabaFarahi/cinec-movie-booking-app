import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/appbar.dart';

class ViewItems extends StatelessWidget {
  const ViewItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'View Items'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Center(child: Text('View Items')),
      ),
    );
  }
}
