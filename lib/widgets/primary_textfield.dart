import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrimaryTextfield extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final int maxLines;
  final FontWeight fontWeight;
  final String fontFamily;
  final String? svgIconPath;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onIconPressed;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;

  const PrimaryTextfield({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.borderRadius = 8.0,
    this.backgroundColor = Colors.transparent,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.black,
    this.fontSize = 15.0,
    this.maxLines = 1,
    this.fontWeight = FontWeight.w500,
    this.fontFamily = 'Outfit',
    this.svgIconPath,
    this.onIconPressed,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<PrimaryTextfield> createState() => _PrimaryTextfieldState();
}

class _PrimaryTextfieldState extends State<PrimaryTextfield> {
  bool _showHide = false;

  void togglePasswordVisibility() {
    setState(() {
      _showHide = !_showHide;
    });
  }

  @override
  void initState() {
    _showHide = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.blue300,
          selectionHandleColor: AppColors.primary,
        ),
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        controller: widget.controller,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText ? _showHide : widget.obscureText,
        validator: widget.validator,
        cursorColor: AppColors.primary,
        textInputAction: widget.textInputAction,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.backgroundColor,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: AppColors.black,
          ),
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16.0,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: widget.fontFamily,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.textColor.withValues(alpha: 0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          suffixIcon: widget.svgIconPath != null
              ? IconButton(
                  onPressed: widget.onIconPressed,
                  icon: SvgPicture.asset(widget.svgIconPath!),
                )
              : widget.obscureText
              ? IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: SvgIcon(
                    _showHide
                        ? 'assets/icons/eye.svg'
                        : 'assets/icons/eye_closed.svg',
                  ),
                )
              : null,
        ),
        style: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.textColor,
        ),
      ),
    );
  }
}
