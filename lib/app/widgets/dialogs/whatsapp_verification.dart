import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../data/services/account_service.dart';
import '../../../i18n/translations.g.dart';
import '../../../app/utils/responsive_helper.dart';

/// Enhanced Dialog for WhatsApp number verification with modern design
class WhatsAppVerificationDialog extends StatefulWidget {
  const WhatsAppVerificationDialog({Key? key}) : super(key: key);

  @override
  State<WhatsAppVerificationDialog> createState() =>
      _WhatsAppVerificationDialogState();
}

class _WhatsAppVerificationDialogState extends State<WhatsAppVerificationDialog>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();

  bool _isCodeSent = false;
  bool _isLoading = false;
  bool _isResending = false;
  String _completePhoneNumber = '';

  late AnimationController _animationController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final AccountService _accountService = Get.find<AccountService>();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _phoneFocusNode.requestFocus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _stepController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _stepController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stepController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  /// Send verification code to WhatsApp number
  Future<void> _sendVerificationCode({bool isResend = false}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (isResend) {
      setState(() {
        _isResending = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final success = await _accountService
          .sendWhatsAppVerificationCode(_completePhoneNumber);

      if (success) {
        setState(() {
          _isCodeSent = true;
          _isLoading = false;
          _isResending = false;
        });

        // Animate to verification step
        await _stepController.forward();
        _codeFocusNode.requestFocus();

        _showSuccessSnackBar(
          t.dialog.whatsapp_verification.code_sent,
          t.dialog.whatsapp_verification.code_sent_message,
        );
      } else {
        setState(() {
          _isLoading = false;
          _isResending = false;
        });

        _showErrorSnackBar(t.common.error, t.messages.error_occurred);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isResending = false;
      });

      _showErrorSnackBar(t.common.error, t.messages.error_occurred);
    }
  }

  /// Verify the entered code
  Future<void> _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showErrorSnackBar(
        t.common.error,
        t.dialog.whatsapp_verification.please_enter_code,
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

        _showSuccessSnackBar(
          t.dialog.whatsapp_verification.whatsapp_verified,
          t.dialog.whatsapp_verification.whatsapp_verified_message,
        );

        // Close the dialog with success
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _isLoading = false;
        });

        _showErrorSnackBar(
          t.dialog.whatsapp_verification.invalid_code,
          t.dialog.whatsapp_verification.invalid_code_message,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar(t.common.error, t.messages.error_occurred);
    }
  }

  void _showSuccessSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dialogWidth = isMobile ? double.infinity : 450.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Container(
                width: dialogWidth,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.green.shade50,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Flexible(child: _buildContent()),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isCodeSent ? Icons.verified_user : Icons.message,
              size: 35,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isCodeSent
                ? t.dialog.whatsapp_verification.verify_whatsapp_number
                : t.dialog.whatsapp_verification.enter_whatsapp_number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isCodeSent ? _buildVerificationStep() : _buildPhoneStep(),
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      key: const ValueKey('phone_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.green.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.dialog.whatsapp_verification.enter_whatsapp_message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
          focusNode: _phoneFocusNode,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputDecoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your WhatsApp number',
            prefixIcon: const Icon(Icons.phone, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.dialog.whatsapp_verification.please_enter_phone;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        key: const ValueKey('verification_step'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.message, color: Colors.blue.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${t.dialog.whatsapp_verification.verification_code_sent} $_completePhoneNumber',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _codeController,
            focusNode: _codeFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: t.dialog.whatsapp_verification.verification_code,
              hintText: t.dialog.whatsapp_verification.enter_6_digit_code,
              prefixIcon: const Icon(Icons.sms, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              counterText: '',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return t.dialog.whatsapp_verification.please_enter_code;
              }
              if (value.length != 6) {
                return t.dialog.whatsapp_verification.code_must_be_6_digits;
              }
              return null;
            },
            onFieldSubmitted: (value) {
              if (value.length == 6 && !_isLoading) {
                _verifyCode();
              }
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _isResending
                  ? null
                  : () => _sendVerificationCode(isResend: true),
              icon: _isResending
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(
                t.dialog.whatsapp_verification.resend_code,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              t.common.cancel,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : _isCodeSent
                    ? _verifyCode
                    : _sendVerificationCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCodeSent ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isCodeSent ? Icons.verified : Icons.send,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCodeSent
                            ? t.dialog.whatsapp_verification.verify
                            : t.dialog.whatsapp_verification.send_code,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
