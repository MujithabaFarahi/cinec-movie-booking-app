import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/widgets/image_icon_builder.dart';
import 'package:flutter/material.dart';

class SelectCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String icon;
  final bool isBordered;

  const SelectCard({
    required this.title,
    this.onTap,
    this.icon = '',
    this.isBordered = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: isBordered ? Border.all(color: AppColors.blue400) : null,
          ),
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.blue200,
            highlightColor: AppColors.blue100,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (icon.isNotEmpty)
                        Container(
                          width: isBordered ? 42 : 48,
                          height: isBordered ? 42 : 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: isBordered
                                  ? AppColors.blue300
                                  : const Color(0xFFE9E9E9),
                            ),
                          ),
                          child: Center(
                            child: ImageIconBuilder(
                              image: icon,
                              isSelected: true,
                              selectedColor: AppColors.blue400,
                            ),
                          ),
                        ),
                      if (icon.isNotEmpty) const SizedBox(width: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ImageIconBuilder(
                    image: 'assets/icons/arrow_right_filled.png',
                    isSelected: true,
                    selectedColor: AppColors.blue400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
