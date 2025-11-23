import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../app/utils/colors.dart';
import '../../../app/utils/app_dialogs.dart';
import '../../../app/utils/responsive_helper.dart';

/// Dialog for creating a new collection with modern design and animations
class AddKoleksiDialog extends StatefulWidget {
  final Function(String) onCollectionCreated;

  const AddKoleksiDialog({
    Key? key,
    required this.onCollectionCreated,
  }) : super(key: key);

  @override
  State<AddKoleksiDialog> createState() => _AddKoleksiDialogState();
}

class _AddKoleksiDialogState extends State<AddKoleksiDialog>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _nameController.addListener(_validateForm);
    _nameFocusNode.requestFocus();
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

  void _validateForm() {
    final isValid = _nameController.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _createCollection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final collectionName = _nameController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onCollectionCreated(collectionName);

      // Show success feedback
      _showSuccessFeedback();

      // Close dialog with success
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Show error feedback
      _showErrorFeedback();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessFeedback() {
    AppSnackbars.showSuccess(
      t.messages.collection_created,
      title: t.collections.title,
    );
  }

  void _showErrorFeedback() {
    AppSnackbars.showError(
      t.messages.error_occurred,
      title: t.common.error,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
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
                      AppColors.surface,
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildForm(),
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
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.collections_bookmark,
            size: 30,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          t.collections.create_new,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.collections.name_hint,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _nameController,
        focusNode: _nameFocusNode,
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        enabled: !_isLoading,
        decoration: InputDecoration(
          labelText: t.collections.name,
          hintText: t.collections.name_hint,
          prefixIcon: Icon(
            Icons.bookmark,
            color: AppColors.primary,
          ),
          suffixIcon: _isFormValid && !_isLoading
              ? Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return t.dialog.please_enter_collection_name;
          }
          if (value.trim().length < 2) {
            return t.dialog.collection_name_too_short;
          }
          if (value.trim().length > 50) {
            return t.dialog.collection_name_too_long;
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (_isFormValid && !_isLoading) {
            _createCollection();
          }
        },
      ),
    );
  }

  Widget _buildActions() {
    return Row(
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
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: _isLoading || !_isFormValid ? null : _createCollection,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textOnPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.collections.save,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
