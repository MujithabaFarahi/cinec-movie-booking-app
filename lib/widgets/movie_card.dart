import 'package:cinec_movies/Models/movie_model.dart';
import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:cinec_movies/widgets/cached_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;
  final bool isLoading;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Stack(
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedImage(url: movie.posterUrl, iconsize: 32),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        movie.title,
                        style: context.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${movie.genre} • ${movie.duration} min',
                        style: context.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        movie.synopsis,
                        style: context.bodySmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),

          movie.nowShowing
              ? Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.success400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      'Screening',
                      style: context.bodySmall.copyWith(color: Colors.white),
                    ),
                  ),
                )
              : Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.danger400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      'No Shows',
                      style: context.bodySmall.copyWith(color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
