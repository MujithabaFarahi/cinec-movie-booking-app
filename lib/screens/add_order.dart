import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/appbar.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Add Order'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Center(child: Text('Add Screen')),
      ),
    );
  }
}
