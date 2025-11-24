import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/app/utils/app_dialogs.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/i18n/translations.g.dart';

/// Image Preview Action Configuration
class ImagePreviewAction {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final bool isDestructive;

  const ImagePreviewAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
    this.isDestructive = false,
  });
}

/// Image Preview Helper Utility
class ImagePreviewHelper {
  /// Show image preview dialog with configurable actions
  static void showImagePreview({
    required BuildContext context,
    required String imageUrl,
    String? tag,
    String? title,
    List<ImagePreviewAction>? actions,
    bool enableHero = true,
    bool enableInteractiveViewer = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return UniversalImagePreviewDialog(
          imageUrl: imageUrl,
          tag: tag ?? 'image_preview_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          actions: actions ?? _getDefaultActions(context, imageUrl),
          enableHero: enableHero,
          enableInteractiveViewer: enableInteractiveViewer,
        );
      },
    );
  }

  /// Get default actions for image preview
  static List<ImagePreviewAction> _getDefaultActions(
      BuildContext context, String imageUrl) {
    return [
      ImagePreviewAction(
        icon: Icons.close,
        label: t.collections.close,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }

  /// Get home view specific actions
  static List<ImagePreviewAction> getHomeViewActions({
    required BuildContext context,
    required String imageUrl,
    required VoidCallback onAddToCollection,
    required VoidCallback onOpenDrawingRoom,
  }) {
    return [
      ImagePreviewAction(
        icon: Icons.bookmark_border,
        label: t.collections.add_to_collection,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        onPressed: () {
          Navigator.of(context).pop();
          onAddToCollection();
        },
      ),
      ImagePreviewAction(
        icon: Icons.brush,
        label: t.collections.draw,
        backgroundColor: AppColors.success,
        foregroundColor: AppColors.white,
        onPressed: () {
          Navigator.of(context).pop();
          onOpenDrawingRoom();
        },
      ),
    ];
  }

  /// Get koleksi gambar view specific actions
  static List<ImagePreviewAction> getKoleksiGambarActions({
    required BuildContext context,
    required String imageUrl,
    required VoidCallback onDelete,
  }) {
    return [
      ImagePreviewAction(
        icon: Icons.close,
        label: t.collections.close,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        onPressed: () => Navigator.of(context).pop(),
      ),
      ImagePreviewAction(
        icon: Icons.delete,
        label: t.common.delete,
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        isDestructive: true,
        onPressed: () {
          Navigator.of(context).pop();
          AppDialogs.showDeleteConfirmation(
            title: t.dialog.confirm_delete_image,
            message: t.dialog.confirm_delete_image_message,
            confirmText: t.common.delete,
            cancelText: t.common.cancel,
            preview: Container(
              height: 150,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onConfirm: onDelete,
          );
        },
      ),
    ];
  }

  /// Truncate text if it's too long
  static String truncateText(String? text, {int maxLength = 20}) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}

/// Universal Image Preview Dialog Widget
class UniversalImagePreviewDialog extends StatefulWidget {
  final String imageUrl;
  final String tag;
  final String? title;
  final List<ImagePreviewAction> actions;
  final bool enableHero;
  final bool enableInteractiveViewer;

  const UniversalImagePreviewDialog({
    super.key,
    required this.imageUrl,
    required this.tag,
    this.title,
    required this.actions,
    this.enableHero = true,
    this.enableInteractiveViewer = true,
  });

  @override
  State<UniversalImagePreviewDialog> createState() =>
      _UniversalImagePreviewDialogState();
}

class _UniversalImagePreviewDialogState
    extends State<UniversalImagePreviewDialog>
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
      begin: 0.9,
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.3),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: _buildImagePreview(context),
                    ),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title ?? t.collections.image_preview,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    final processedUrl = ApiConfig.getImageUrl(widget.imageUrl);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: widget.enableHero
            ? Hero(
                tag: widget.tag,
                child: _buildImageViewer(context, processedUrl),
              )
            : _buildImageViewer(context, processedUrl),
      ),
    );
  }

  Widget _buildImageViewer(BuildContext context, String processedUrl) {
    final imageWidget = processedUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: processedUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.error,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    t.collections.failed_to_load_image,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: Theme.of(context).colorScheme.error,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  t.collections.no_image_available,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );

    return widget.enableInteractiveViewer
        ? InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            boundaryMargin: const EdgeInsets.all(20),
            child: imageWidget,
          )
        : imageWidget;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: widget.actions.length <= 2
          ? Row(
              children: widget.actions
                  .map((action) => Expanded(
                        child: Padding(
                          padding: widget.actions.indexOf(action) == 0
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(left: 12),
                          child: _buildActionButton(context, action),
                        ),
                      ))
                  .toList(),
            )
          : Column(
              children: widget.actions
                  .map((action) => Padding(
                        padding: widget.actions.indexOf(action) == 0
                            ? EdgeInsets.zero
                            : const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(context, action),
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildActionButton(BuildContext context, ImagePreviewAction action) {
    return ElevatedButton.icon(
      onPressed: action.onPressed,
      icon: Icon(action.icon),
      label: Text(action.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: action.backgroundColor,
        foregroundColor: action.foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}
