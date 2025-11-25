import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logger.dart';

class AppErrorHandler {
  static void handleError(dynamic error,
      {String? context, StackTrace? stackTrace}) {
    Logger.error('Error occurred', tag: context, error: error);

    String userMessage = _getUserFriendlyMessage(error);

    Get.snackbar(
      'Error',
      userMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void handleErrorWithoutSnackbar(dynamic error,
      {String? context, StackTrace? stackTrace}) {
    Logger.error('Error occurred', tag: context, error: error);
  }

  static String getUserFriendlyMessage(dynamic error, {String? context}) {
    Logger.error('Getting user friendly message', tag: context, error: error);
    return _getUserFriendlyMessage(error);
  }

  static String _getUserFriendlyMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is Exception) {
      return _handleException(error);
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response?.statusCode ?? 0);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please contact support.';
      case DioExceptionType.unknown:
        return 'Network error occurred. Please try again.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  static String _handleHttpError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again later.';
      default:
        return 'Server error occurred. Please try again later.';
    }
  }

  static String _handleException(Exception exception) {
    if (exception.toString().contains('IsarError')) {
      return 'Database error occurred. Please restart the app.';
    } else if (exception.toString().contains('FileSystemException')) {
      return 'File system error. Please check your storage.';
    } else if (exception.toString().contains('FormatException')) {
      return 'Data format error. Please try again.';
    }
    return 'An error occurred: ${exception.toString()}';
  }

  static void showCustomErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void showNetworkErrorDialog() {
    showCustomErrorDialog(
      'Network Error',
      'Please check your internet connection and try again.',
    );
  }

  static void showServerErrorDialog() {
    showCustomErrorDialog(
      'Server Error',
      'Server is temporarily unavailable. Please try again later.',
    );
  }
}
