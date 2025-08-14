import 'package:cinec_movies/theme/app_colors.dart';
import 'package:cinec_movies/theme/theme_extension.dart';
import 'package:cinec_movies/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum ToastType { success, error, info, warning }

abstract class CoreUtils {
  const CoreUtils();

  static void postFrameCall(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      // showToast(type: ToastType.error, message: "Failed to initiate a call");
    }
  }

  static void sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);

    if (!await launchUrl(launchUri)) {
      // showToast(type: ToastType.error, message: "Failed to open email client");
    }
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  // static void heroDialog(Widget child) {
  //   Navigator.push(
  //     rootNavigatorKey.currentState!.context,
  //     HeroDialogRoute(builder: (_) => child),
  //   );
  // }

  static void showBottomSheet(Widget child) {
    showModalBottomSheet(
      context: rootNavigatorKey.currentState!.context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => child,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  static Future<DateTime?> datePicker({DateTime? selectedDate}) async {
    final DateTime? picked = await showDatePicker(
      context: rootNavigatorKey.currentContext!,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
    return picked;
  }

  static void pickImageFromGallery(
    ImagePicker picker,
    Function(List<XFile>) onImagesPicked,
  ) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        onImagesPicked([pickedFile]);
      } else {
        toastError(title: 'Empty', 'No image selected from gallery.');
      }
    } catch (e) {
      toastError(title: 'Error', 'Failed to pick image from gallery: $e');
    }
  }

  static void toastSuccess(String message, {String title = "Success"}) {
    debugPrint(message);
    CoreUtils._toast(
      title: title,
      message: message,
      type: ToastificationType.success,
      color: AppColors.success,
    );
  }

  static void toastError(String message, {String title = "Error"}) {
    debugPrint(message);
    CoreUtils._toast(
      title: title,
      message: message,
      type: ToastificationType.error,
      color: AppColors.danger600,
    );
  }

  static void _toast({
    required String title,
    required String message,
    required ToastificationType type,
    required Color color,
  }) {
    toastification.dismissAll();
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(
        title,
        style: rootNavigatorKey.currentContext!.bodyLarge.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: rootNavigatorKey.currentContext!.bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return GestureDetector(
            onTap: onClose,
            child: SvgIcon(
              'assets/icons/close_circle.svg',
              color: AppColors.white,
            ),
          );
        },
      ),
      closeOnClick: false,
      dragToClose: true,
      showIcon: false,
      alignment: Alignment.topCenter,
      primaryColor: color,
      autoCloseDuration: const Duration(seconds: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
