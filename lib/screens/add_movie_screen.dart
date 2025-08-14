import 'dart:io';
import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/blocs/movie/movie_bloc.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/utils/core_utils.dart';
import 'package:cinec_movies/widgets/appbar.dart';
import 'package:cinec_movies/widgets/cached_image.dart';
import 'package:cinec_movies/widgets/custom_switch.dart';
import 'package:cinec_movies/widgets/primary_button.dart';
import 'package:cinec_movies/widgets/primary_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddMovieScreen extends StatefulWidget {
  final bool isEditMode;
  const AddMovieScreen({super.key, this.isEditMode = false});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _synopsisController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _nowShowing = false;
  XFile? _selectedImage;
  bool _isLoading = false;
  MovieModel? movie;

  @override
  void initState() {
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movie = movieBloc.state.movie!;
    if (widget.isEditMode && movie != null) {
      _titleController.text = movie!.title;
      _genreController.text = movie!.genre;
      _durationController.text = movie!.duration.toString();
      _synopsisController.text = movie!.synopsis;
      _nowShowing = movie!.nowShowing;
      _selectedImage = null;
    }
    super.initState();
  }

  void _onImagePicked(List<XFile> images) {
    if (images.isNotEmpty) {
      setState(() {
        _selectedImage = images.first;
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final fileId =
        '${_titleController.text.trim()}_${DateTime.now().millisecondsSinceEpoch}';
    final storageRef = FirebaseStorage.instance.ref().child(
      'movie_posters/$fileId.jpg',
    );

    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  Future<void> _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;
    if (!widget.isEditMode && _selectedImage == null) {
      CoreUtils.toastError('Please select a poster image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String posterUrl = '';
      if (_selectedImage != null) {
        posterUrl = await _uploadImage(File(_selectedImage!.path));
      } else if (widget.isEditMode) {
        // Keep existing poster in edit mode
        posterUrl = movie!.posterUrl;
      }

      final docRef = widget.isEditMode
          ? FirebaseFirestore.instance.collection('movies').doc(movie!.id)
          : FirebaseFirestore.instance.collection('movies').doc();

      await docRef.set({
        'id': docRef.id,
        'title': _titleController.text.trim(),
        'genre': _genreController.text.trim(),
        'duration': int.tryParse(_durationController.text.trim()) ?? 0,
        'synopsis': _synopsisController.text.trim(),
        'posterUrl': posterUrl,
        'createdAt': widget.isEditMode
            ? movie!.createdAt.toIso8601String()
            : DateTime.now().toIso8601String(),
        'nowShowing': _nowShowing,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      widget.isEditMode
          ? CoreUtils.toastError('Failed to update movie: $e')
          : CoreUtils.toastError('Failed to add movie: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEditMode ? 'Edit Movie' : 'Add Movie',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            children: [
              GestureDetector(
                onTap: () {
                  CoreUtils.pickImageFromGallery(_picker, _onImagePicked);
                },
                child: _selectedImage != null
                    ? AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : widget.isEditMode
                    ? BlocBuilder<MovieBloc, MovieState>(
                        builder: (context, state) {
                          return AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedImage(url: state.movie!.posterUrl),
                            ),
                          );
                        },
                      )
                    : AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          // alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/gallery.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColors.primary,
                                  BlendMode.srcIn,
                                ),
                                width: 40,
                              ),
                              Text(
                                'Tap to select poster',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              PrimaryTextfield(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Enter movie title',
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              PrimaryTextfield(
                controller: _genreController,
                labelText: 'Genre',
                hintText: 'Enter movie genre',
                validator: (value) => value!.isEmpty ? 'Enter genre' : null,
              ),
              PrimaryTextfield(
                controller: _durationController,
                keyboardType: TextInputType.number,
                labelText: 'Duration (minutes)',
                hintText: 'Enter duration in minutes',
                validator: (value) => value!.isEmpty ? 'Enter duration' : null,
              ),
              PrimaryTextfield(
                controller: _synopsisController,
                labelText: 'Synopsis',
                hintText: 'Enter movie synopsis',
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter synopsis' : null,
              ),
              Row(
                children: [
                  Text(
                    'Now Showing',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 8),
                  CustomSwitchButton(
                    value: _nowShowing,
                    onChanged: (value) {
                      setState(() => _nowShowing = value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          text: widget.isEditMode ? 'Update Movie' : 'Add Movie',
          onPressed: _saveMovie,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
