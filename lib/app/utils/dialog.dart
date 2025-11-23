import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';
import 'responsive_helper.dart';

/// Enhanced confirmation dialog with modern design and animations
Future<bool?> showConfirmationDialog({
  String? title,
  String? subtitle,
  String? textConfirm,
  String? textCancel,
  IconData? icon,
  Color? iconColor,
  Function()? onConfirm,
  Function()? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernConfirmationDialog(
      title: title ?? 'Confirm',
      subtitle: subtitle ?? '',
      textConfirm: textConfirm ?? 'Yes',
      textCancel: textCancel ?? 'No',
      icon: icon ?? Icons.help_outline,
      iconColor: iconColor ?? Colors.orange,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}

/// Enhanced popup dialog with modern design and animations
Future<void> showPopupDialog({
  String? title,
  String? subtitle,
  String? buttonText,
  IconData? icon,
  Color? iconColor,
  Function()? onConfirm,
  Function()? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernPopupDialog(
      title: title ?? 'Attention',
      subtitle: subtitle ?? '',
      buttonText: buttonText ?? 'OK',
      icon: icon ?? Icons.info_outline,
      iconColor: iconColor ?? Colors.blue,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}

/// Success dialog with modern design and animations
Future<void> showSuccessDialog({
  String? title,
  String? subtitle,
  String? buttonText,
  Function()? onConfirm,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernPopupDialog(
      title: title ?? 'Success',
      subtitle: subtitle ?? '',
      buttonText: buttonText ?? 'OK',
      icon: Icons.check_circle,
      iconColor: Colors.green,
      onConfirm: onConfirm,
    ),
  );
}

/// Error dialog with modern design and animations
Future<void> showErrorDialog({
  String? title,
  String? subtitle,
  String? buttonText,
  Function()? onConfirm,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernPopupDialog(
      title: title ?? 'Error',
      subtitle: subtitle ?? 'An error occurred. Please try again.',
      buttonText: buttonText ?? 'OK',
      icon: Icons.error,
      iconColor: Colors.red,
      onConfirm: onConfirm,
    ),
  );
}

/// Loading dialog with modern design and animations
Future<void> showLoadingDialog({
  String? title,
  String? subtitle,
  bool barrierDismissible = false,
}) {
  return showDialog(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernLoadingDialog(
      title: title ?? 'Loading...',
      subtitle: subtitle,
    ),
  );
}

/// Custom dialog with any content
Future<T?> showCustomDialog<T>({
  required Widget content,
  String? title,
  EdgeInsets? padding,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: Get.context!,
    barrierDismissible: barrierDismissible,
    builder: (context) => _ModernCustomDialog(
      title: title,
      content: content,
      padding: padding,
    ),
  );
}

/// Legacy functions for backward compatibility
dialogKonfirmasi({
  String? title,
  String? subtitle,
  String? textConfirm,
  Function()? onConfirm,
  Function()? onCancel,
}) {
  return showConfirmationDialog(
    title: title,
    subtitle: subtitle,
    textConfirm: textConfirm,
    onConfirm: onConfirm,
    onCancel: onCancel,
  );
}

dialogPopUp({
  String? title,
  String? subtitle,
  Function()? onConfirm,
  Function()? onCancel,
}) {
  return showPopupDialog(
    title: title,
    subtitle: subtitle,
    onConfirm: onConfirm,
    onCancel: onCancel,
  );
}

/// Modern confirmation dialog widget
class _ModernConfirmationDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String textConfirm;
  final String textCancel;
  final IconData icon;
  final Color iconColor;
  final Function()? onConfirm;
  final Function()? onCancel;

  const _ModernConfirmationDialog({
    required this.title,
    required this.subtitle,
    required this.textConfirm,
    required this.textCancel,
    required this.icon,
    required this.iconColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  State<_ModernConfirmationDialog> createState() =>
      _ModernConfirmationDialogState();
}

class _ModernConfirmationDialogState extends State<_ModernConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dialogWidth = isMobile ? double.infinity : 400.0;

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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildContent(),
                    const SizedBox(height: 24),
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        size: 30,
        color: widget.iconColor,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onCancel ?? () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.textCancel,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: widget.onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.iconColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Text(
            widget.textConfirm,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

/// Modern popup dialog widget
class _ModernPopupDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final Color iconColor;
  final Function()? onConfirm;
  final Function()? onCancel;

  const _ModernPopupDialog({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.iconColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  State<_ModernPopupDialog> createState() => _ModernPopupDialogState();
}

class _ModernPopupDialogState extends State<_ModernPopupDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dialogWidth = isMobile ? double.infinity : 400.0;

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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      widget.iconColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildContent(),
                    const SizedBox(height: 24),
                    _buildAction(),
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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        size: 30,
        color: widget.iconColor,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildAction() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onConfirm ?? () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.iconColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          widget.buttonText,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

/// Modern loading dialog widget
class _ModernLoadingDialog extends StatefulWidget {
  final String title;
  final String? subtitle;

  const _ModernLoadingDialog({
    required this.title,
    this.subtitle,
  });

  @override
  State<_ModernLoadingDialog> createState() => _ModernLoadingDialogState();
}

class _ModernLoadingDialogState extends State<_ModernLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final dialogWidth = isMobile ? double.infinity : 300.0;

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
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      cornFlower.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: cornFlower.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cornFlower),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Modern custom dialog widget
class _ModernCustomDialog extends StatefulWidget {
  final String? title;
  final Widget content;
  final EdgeInsets? padding;

  const _ModernCustomDialog({
    this.title,
    required this.content,
    this.padding,
  });

  @override
  State<_ModernCustomDialog> createState() => _ModernCustomDialogState();
}

class _ModernCustomDialogState extends State<_ModernCustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                padding: widget.padding ?? const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null) ...[
                      Text(
                        widget.title!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    widget.content,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
