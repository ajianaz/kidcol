import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/utils/constants.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/app/utils/app_dialogs.dart';
import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Enhanced collection selection dialog with modern design
    void showCollectionDialog(String imageUrl) {
      if (controller.koleksis.isEmpty) {
        controller.dialogAddKoleksi();
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _ModernCollectionDialog(
            koleksis: controller.koleksis,
            imageUrl: imageUrl,
            onSave: (koleksi) async {
              try {
                var data = Gambar()..endpoint = imageUrl;
                // Pass koleksi as parameter instead of adding to backlink
                await controller.service.saveGambar(data, koleksis: [koleksi]);
                Get.back();

                // Show success notification
                AppSnackbars.showSuccess(
                  t.messages.image_added_to_collection,
                  title: t.common.success,
                );
              } catch (e) {
                Get.back();

                // Show error notification
                AppSnackbars.showError(
                  t.messages.image_failed_to_add_to_collection,
                  title: t.common.error,
                );
                debugPrint('Error saving image to collection: $e');
              }
            },
          );
        },
      );
    }

    // Image preview dialog with zoom and pan functionality
    void showImagePreviewDialog(String imageUrl) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return _ImagePreviewDialog(
            imageUrl: imageUrl,
            onAddToCollection: () {
              Navigator.of(context).pop();
              showCollectionDialog(imageUrl);
            },
            onOpenDrawingRoom: () {
              Navigator.of(context).pop();
              Get.toNamed(Routes.DRAWING_ROOM, arguments: imageUrl);
            },
          );
        },
      );
    }

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (val) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              t.home.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            elevation: 1,
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              controller.resetData();
              await controller.requestData();
            },
            color: AppColors.primary,
            displacement: 40,
            child: Container(
              decoration: _buildBackgroundDecoration(),
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  // Content Section with spacing
                  SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),

                  if (controller.isLoading.value && controller.assets.isEmpty)
                    _buildLoadingState()
                  else if (controller.assets.isEmpty)
                    _buildEmptyState(context)
                  else
                    _buildImageGrid(
                        context, controller, showImagePreviewDialog),

                  // Add bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Background decoration with subtle gradient
BoxDecoration _buildBackgroundDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.surface,
        AppColors.primary.withValues(alpha: 0.03),
        AppColors.secondary.withValues(alpha: 0.02),
      ],
      stops: const [0.0, 0.6, 1.0],
    ),
  );
}

// Loading state with shimmer effect
Widget _buildLoadingState() {
  return SliverPadding(
    padding: AppPadding.getResponsiveAllPadding(Get.context!),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getCrossAxisCount(Get.context!),
        crossAxisSpacing: AppSpacing.gridCrossAxisSpacing,
        mainAxisSpacing: AppSpacing.gridMainAxisSpacing,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _CustomShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
            ),
          );
        },
        childCount: 12, // Show 12 shimmer placeholders
      ),
    ),
  );
}

// Empty state with engaging animation
Widget _buildEmptyState(BuildContext context) {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.image_search_outlined,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          t.images.empty,
          style: TextStyle(
            fontSize: ResponsiveHelper.isMobile(context) ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Pull down to refresh or check your connection",
          style: TextStyle(
            fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {
            final homeController = Get.find<HomeController>();
            homeController.resetData();
            homeController.requestData();
          },
          icon: const Icon(Icons.refresh),
          label: Text(t.common.loading),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 2,
          ),
        ),
      ],
    ),
  );
}

// Enhanced image grid with staggered animations
Widget _buildImageGrid(
  BuildContext context,
  HomeController controller,
  Function(String) showImagePreviewDialog,
) {
  return SliverPadding(
    padding: AppPadding.getResponsiveAllPadding(context),
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
        crossAxisSpacing: AppSpacing.gridCrossAxisSpacing + 8,
        mainAxisSpacing: AppSpacing.gridMainAxisSpacing + 8,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var asset = controller.assets[index];
          return _AnimatedGridItem(
            index: index,
            child: _EnhancedImageCard(
              imageUrl: "${asset.imageUrl}",
              onTap: () => showImagePreviewDialog("${asset.imageUrl}"),
            ),
          );
        },
        childCount: controller.assets.length,
      ),
    ),
  );
}

// Custom shimmer effect
class _CustomShimmer extends StatefulWidget {
  final Widget child;

  const _CustomShimmer({required this.child});

  @override
  State<_CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<_CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Animated grid item
class _AnimatedGridItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedGridItem({required this.index, required this.child});

  @override
  State<_AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<_AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Enhanced image card with better styling and animations
class _EnhancedImageCard extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _EnhancedImageCard({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<_EnhancedImageCard> createState() => _EnhancedImageCardState();
}

class _EnhancedImageCardState extends State<_EnhancedImageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: _isPressed ? 2 : 1,
                    blurRadius: _isPressed ? 8 : 4,
                    offset: Offset(0, _isPressed ? 4 : 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Image
                    _EnhancedCardImage(imageUrl: widget.imageUrl),

                    // Gradient overlay for better text visibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Hint text
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        t.ui.tap_to_view,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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

// Enhanced card image component
class _EnhancedCardImage extends StatelessWidget {
  final String imageUrl;

  const _EnhancedCardImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final processedUrl = ApiConfig.getImageUrl(imageUrl);

    return processedUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: processedUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceLight,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.grey400,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.error.failed_to_load_images,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            fadeInDuration: const Duration(milliseconds: 300),
            memCacheWidth: 300,
            memCacheHeight: 300,
          )
        : Container(
            color: AppColors.surfaceLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey400,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  t.images.empty,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
  }
}

/// Modern collection selection dialog with enhanced design
class _ModernCollectionDialog extends StatefulWidget {
  final List<dynamic> koleksis;
  final String imageUrl;
  final Function(dynamic) onSave;

  const _ModernCollectionDialog({
    required this.koleksis,
    required this.imageUrl,
    required this.onSave,
  });

  @override
  State<_ModernCollectionDialog> createState() =>
      _ModernCollectionDialogState();
}

class _ModernCollectionDialogState extends State<_ModernCollectionDialog>
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
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
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
                    const SizedBox(height: 20),
                    _buildCollectionList(),
                    const SizedBox(height: 20),
                    _buildCloseButton(),
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
          t.collections.view_images,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.collections.select_collection,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.koleksis.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var koleksi = widget.koleksis[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onSave(koleksi),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.bookmark,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          koleksi.title ?? t.collections.untitled_collection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          t.collections.close,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Modern image preview dialog with zoom and pan functionality
class _ImagePreviewDialog extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onAddToCollection;
  final VoidCallback onOpenDrawingRoom;

  const _ImagePreviewDialog({
    required this.imageUrl,
    required this.onAddToCollection,
    required this.onOpenDrawingRoom,
  });

  @override
  State<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<_ImagePreviewDialog>
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
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.3),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _buildImagePreview(),
                    ),
                    _buildActionButtons(),
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
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t.collections.image_preview,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    final processedUrl = ApiConfig.getImageUrl(widget.imageUrl);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(20),
          child: processedUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: processedUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.grey400,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.collections.failed_to_load_image,
                          style: TextStyle(
                            color: AppColors.textSecondary,
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
                        color: AppColors.grey400,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.collections.no_image_available,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: widget.onAddToCollection,
              icon: const Icon(Icons.bookmark_border),
              label: Text(t.collections.add_to_collection),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: widget.onOpenDrawingRoom,
              icon: const Icon(Icons.brush),
              label: Text(t.collections.draw),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
