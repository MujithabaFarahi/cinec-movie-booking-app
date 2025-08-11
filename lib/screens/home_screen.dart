import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home Screen'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Welcome to the Home Screen!'),
              Wrap(
                runSpacing: 10,
                children: [
                  TextField(),
                  ElevatedButton(onPressed: () {}, child: const Text('Submit')),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                runSpacing: 10,
                children: [
                  PrimaryTextfield(hintText: 'Type here...', labelText: 'Name'),
                  PrimaryButton(text: 'Submit', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
