import 'package:cinec_movies/Models/user_model.dart';
import 'package:cinec_movies/utils/validators.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/utils/core_utils.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .update({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
          });

      CoreUtils.toastSuccess('Profile updated successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      CoreUtils.toastError('Failed to update profile: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PrimaryTextfield(
              controller: _nameController,
              hintText: 'Enter your name',
              labelText: 'Name',
              validator: Validators.name,
            ),
            const SizedBox(height: 16),
            PrimaryTextfield(
              controller: _emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              validator: Validators.email,
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            PrimaryTextfield(
              controller: _phoneController,
              hintText: 'Enter your phone number',
              labelText: 'Phone',
              validator: Validators.mobileNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
