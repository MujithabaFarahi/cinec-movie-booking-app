import 'package:cinec_movies/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconData {
  final String path;
  const SvgIconData(this.path);
}

class SvgIcon extends StatelessWidget {
  final String icon;
  final double? size;
  final Color? color;

  const SvgIcon(this.icon, {super.key, this.size, this.color});

  const SvgIcon.white(this.icon, {super.key, this.size})
    : color = AppColors.white;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: ColorFilter.mode(color ?? AppColors.black, BlendMode.srcIn),
    );
  }
}
