// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';

import 'package:kidcol/app/utils/app_dialogs.dart';
import 'package:kidcol/app/utils/constants.dart';
import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/app/widgets/cards/card_image.dart';
import 'package:kidcol/i18n/translations.g.dart';

import '../controllers/koleksi_gambar_controller.dart';

class KoleksiGambarView extends GetView<KoleksiGambarController> {
  const KoleksiGambarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KoleksiGambarController>(
      init: KoleksiGambarController(),
      builder: (controllerContext) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${t.collection.title_prefix} ${controller.koleksi.title}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.isMobile(Get.context!) ? 18 : 20,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(Get.context!).colorScheme.onSurface,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.print,
                      onTap: () => Get.toNamed(Routes.PRINTING_PDF,
                          arguments: controller.koleksi),
                    ),
                    SizedBox(width: 16),
                    _buildActionButton(
                      icon: Icons.delete,
                      onTap: () => controller.konfirmasiHapusKoleksi(),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: ConstrainedBox(
            constraints:
                ResponsiveHelper.getResponsiveContainerConstraints(context),
            child: StreamBuilder(
              stream: controller.service.listenToGambars(controller.koleksi),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final items = snapshot.data;
                  if (items!.isNotEmpty) {
                    return _buildImageGrid(items);
                  } else {
                    return _buildEmptyState();
                  }
                }
                return _buildLoadingState();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(Get.context!)
                .colorScheme
                .shadow
                .withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Theme.of(Get.context!).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(List items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: ResponsiveHelper.getCenteredContentPadding(context),
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var gambar = items.elementAt(index);
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOut,
                child: _buildImageCard(gambar, index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImageCard(gambar, int index) {
    return Hero(
      tag: 'image_${gambar.id ?? index}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showImagePreview(gambar, index),
          onLongPress: () => _showImageOptions(gambar),
          child: CardImage(
            imageUrl: "${gambar.endpoint}",
          ),
        ),
      ),
    );
  }

  void _showImagePreview(gambar, int index) {
    Get.to(
      () => _ImagePreviewPage(
        imageUrl: "${gambar.endpoint}",
        tag: 'image_${gambar.id ?? index}',
        onDelete: () => controller.deleteGambarKoleksi(gambar),
      ),
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
  }

  void _showImageOptions(gambar) {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getResponsiveDialogWidth(context),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16),
              Text(
                t.common.confirm,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.preview,
                    color: Theme.of(Get.context!).colorScheme.primary),
                title: Text(t.images.view),
                onTap: () {
                  Get.back();
                  _showImagePreview(gambar, 0);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete,
                    color: Theme.of(Get.context!).colorScheme.error),
                title: Text(t.common.delete),
                onTap: () {
                  Get.back();
                  _confirmDeleteImage(gambar);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteImage(gambar) {
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
            imageUrl: "${gambar.endpoint}",
            fit: BoxFit.cover,
          ),
        ),
      ),
      onConfirm: () => controller.deleteGambarKoleksi(gambar),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.surface,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 100,
              color: Theme.of(Get.context!)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: AppPadding.lg),
          Text(
            t.dialog.no_images,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(Get.context!)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppPadding.sm),
          Text(
            "Start adding images to this collection",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(Get.context!)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(Get.context!).colorScheme.primary,
            ),
          ),
          SizedBox(height: AppPadding.md),
          Text(
            t.common.loading,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(Get.context!)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(Get.context!)
                  .colorScheme
                  .error
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Theme.of(Get.context!).colorScheme.error,
            ),
          ),
          SizedBox(height: AppPadding.lg),
          Text(
            t.common.error,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(Get.context!)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppPadding.sm),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.lg),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(Get.context!)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppPadding.md),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(Get.context!).colorScheme.primary,
              foregroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.lg, vertical: AppPadding.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Go Back"),
          ),
        ],
      ),
    );
  }
}

class _ImagePreviewPage extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final VoidCallback onDelete;

  const _ImagePreviewPage({
    required this.imageUrl,
    required this.tag,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: "Delete Image",
                titleStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                middleTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                content: Text(
                  "Are you sure you want to delete this image?",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7)),
                ),
                textConfirm: "Delete",
                textCancel: "Cancel",
                confirmTextColor: Theme.of(context).colorScheme.onPrimary,
                cancelTextColor: Theme.of(context).colorScheme.onPrimary,
                buttonColor: Theme.of(context).colorScheme.error,
                onConfirm: () {
                  Get.back();
                  Get.back();
                  onDelete();
                },
                onCancel: () => Get.back(),
                backgroundColor: Theme.of(context).colorScheme.surface,
                radius: 12,
                titlePadding: EdgeInsets.all(16),
                contentPadding: EdgeInsets.all(16),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.onSurface,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
