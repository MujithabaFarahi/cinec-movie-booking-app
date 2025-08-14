import 'package:cinec_movies/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onIconPressed;
  final String icon;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = false,
    this.onBackPressed,
    this.onIconPressed,
    this.icon = 'assets/icons/edit.svg',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title.isNotEmpty
          ? Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            )
          : null,
      centerTitle: true,
      elevation: 0,
      // automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(
              icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: <Widget>[
        onIconPressed != null
            ? IconButton(
                icon: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: onIconPressed,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
