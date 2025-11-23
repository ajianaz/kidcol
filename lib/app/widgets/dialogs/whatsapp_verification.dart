import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../data/services/account_service.dart';

/// Dialog for WhatsApp number verification
class WhatsAppVerificationDialog extends StatefulWidget {
  const WhatsAppVerificationDialog({Key? key}) : super(key: key);

  @override
  State<WhatsAppVerificationDialog> createState() =>
      _WhatsAppVerificationDialogState();
}

class _WhatsAppVerificationDialogState
    extends State<WhatsAppVerificationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isCodeSent = false;
  bool _isLoading = false;
  String _completePhoneNumber = '';
  String _selectedCountry = 'ID'; // Default to Indonesia

  final AccountService _accountService = Get.find<AccountService>();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// Send verification code to WhatsApp number
  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _accountService
          .sendWhatsAppVerificationCode(_completePhoneNumber);

      if (success) {
        setState(() {
          _isCodeSent = true;
          _isLoading = false;
        });

        Get.snackbar(
          'Code Sent',
          'A verification code has been sent to your WhatsApp number',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar(
          'Error',
          'Failed to send verification code',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Get.snackbar(
        'Error',
        'An error occurred while sending the verification code',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Verify the entered code
  Future<void> _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the verification code',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _accountService.verifyWhatsAppCodeAndLock(
        _completePhoneNumber,
        _codeController.text.trim(),
      );

      if (success) {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar(
          'Verified',
          'Your WhatsApp number has been verified successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Close the dialog
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar(
          'Invalid Code',
          'The verification code you entered is invalid',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Get.snackbar(
        'Error',
        'An error occurred while verifying the code',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isCodeSent ? 'Verify WhatsApp Number' : 'Enter WhatsApp Number',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isCodeSent) ...[
                const Text(
                  'Please enter your WhatsApp number to verify your account',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    _completePhoneNumber = number.phoneNumber ?? '';
                  },
                  onInputValidated: (bool value) {
                    // Validation is handled by the widget
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  countries: const ['ID'],
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  textFieldController: _phoneController,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputBorder: const OutlineInputBorder(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ] else ...[
                Text(
                  'A verification code has been sent to $_completePhoneNumber',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    hintText: 'Enter 6-digit code',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (_isCodeSent)
          TextButton(
            onPressed: _isLoading ? null : _sendVerificationCode,
            child: const Text('Resend Code'),
          ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : _isCodeSent
                  ? _verifyCode
                  : _sendVerificationCode,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isCodeSent ? 'Verify' : 'Send Code'),
        ),
      ],
    );
  }
}
