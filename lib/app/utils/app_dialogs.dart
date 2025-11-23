import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kidcol/app/utils/app_theme.dart';

/// Consistent Dialog Helpers
/// Provides pre-styled dialogs with consistent theming
class AppDialogs {
  /// Show a success dialog
  static void showSuccess({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText: message,
      middleTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: onConfirm ?? () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    );
  }

  /// Show an error dialog
  static void showError({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.error,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText: message,
      middleTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: onConfirm ?? () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmation({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
    bool isDestructive = false,
  }) {
    final effectiveConfirmColor =
        isDestructive ? AppColors.error : (confirmColor ?? AppColors.primary);

    return Get.defaultDialog<bool>(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: effectiveConfirmColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: effectiveConfirmColor,
                size: 30,
              ),
            ),
            SizedBox(height: 16),
          ],
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(result: true);
          onConfirm?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveConfirmColor,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'Confirm'),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back(result: false);
          onCancel?.call();
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(cancelText ?? 'Cancel'),
      ),
    );
  }

  /// Show a delete confirmation dialog
  static void showDeleteConfirmation({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Widget? preview,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.error,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (preview != null) ...[
            preview,
            SizedBox(height: 16),
          ],
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline,
              color: AppColors.error,
              size: 30,
            ),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          onConfirm();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'Delete'),
      ),
      cancel: TextButton(
        onPressed: onCancel ?? () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(cancelText ?? 'Cancel'),
      ),
    );
  }

  /// Show an info dialog
  static void showInfo({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.info,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText: message,
      middleTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: onConfirm ?? () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.info,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    );
  }

  /// Show a warning dialog
  static void showWarning({
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.warning,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText: message,
      middleTextStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      backgroundColor: AppColors.surface,
      radius: 20,
      confirm: ElevatedButton(
        onPressed: onConfirm ?? () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    );
  }
}

/// Consistent Snackbar Helpers
class AppSnackbars {
  /// Show a success snackbar
  static void showSuccess(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      icon: Icon(Icons.check_circle, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }

  /// Show an error snackbar
  static void showError(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Error',
      message,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      icon: Icon(Icons.error, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  /// Show an info snackbar
  static void showInfo(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      icon: Icon(Icons.info, color: AppColors.white),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }

  /// Show a warning snackbar
  static void showWarning(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Warning',
      message,
      backgroundColor: AppColors.warning,
      colorText: AppColors.textPrimary,
      icon: Icon(Icons.warning, color: AppColors.textPrimary),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }
}
