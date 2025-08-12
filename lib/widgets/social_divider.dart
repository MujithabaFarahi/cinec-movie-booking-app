import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.gray300, height: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'OR',
              style: context.titleMedium.copyWith(
                color: AppColors.gunmetal600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.gray300, height: 1)),
        ],
      ),
    );
  }
}
