import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/data/entities/gambar.dart';
import 'package:kidcol/app/utils/constants.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/app/widgets/cards/card_image.dart';
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
            onSave: (koleksi) {
              var data = Gambar()..endpoint = imageUrl;
              data.koleksis.add(koleksi);
              controller.service.saveGambar(data);
              Get.back();
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
          body: Stack(
            children: [
              !controller.isLoading.value
                  ? controller.assets.isNotEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return Padding(
                              padding:
                                  AppPadding.getResponsiveAllPadding(context),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveHelper.getCrossAxisCount(
                                          context),
                                  crossAxisSpacing:
                                      AppSpacing.gridCrossAxisSpacing,
                                  mainAxisSpacing:
                                      AppSpacing.gridMainAxisSpacing,
                                  childAspectRatio:
                                      0.8, // Adjust aspect ratio as needed
                                ),
                                controller: controller.scrollController,
                                itemCount: controller.assets.length,
                                itemBuilder: (context, index) {
                                  var asset = controller.assets[index];
                                  return InkWell(
                                    onTap: () {
                                      showImagePreviewDialog(
                                          "${asset.imageUrl}");
                                    },
                                    onDoubleTap: () {
                                      Get.toNamed(Routes.DRAWING_ROOM,
                                          arguments: "${asset.imageUrl}");
                                    },
                                    child: CardImage(
                                      imageUrl: "${asset.imageUrl}",
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const SizedBox()
                  : const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
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
                      Colors.white,
                      cornFlower.withValues(alpha: 0.05),
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
            color: cornFlower.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.collections_bookmark,
            size: 30,
            color: cornFlower,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          t.collections.view_images,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a collection to add this image',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cornFlower.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
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
                          color: cornFlower.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.bookmark,
                          color: cornFlower,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          koleksi.title ?? 'Untitled Collection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: cornFlower,
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
          'Close',
          style: TextStyle(
            color: Colors.grey.shade600,
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
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
            cornFlower,
            cornFlower.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Image Preview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
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
        color: Colors.grey.shade100,
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
                      valueColor: AlwaysStoppedAnimation<Color>(cornFlower),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: Colors.grey.shade600,
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
                        color: Colors.grey.shade400,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No image available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
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
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
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
              label: Text('Add to Collection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cornFlower,
                foregroundColor: Colors.white,
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
              label: Text('Draw'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
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
