// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/routes/app_pages.dart';
import 'package:kidcol/app/utils/colors.dart';
import 'package:kidcol/i18n/translations.g.dart';
import 'package:kidcol/app/widgets/dialogs/add_koleksi.dart';
import '../controllers/koleksi_controller.dart';

class KoleksiView extends GetView<KoleksiController> {
  KoleksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KoleksiController>(
        init: KoleksiController(),
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                t.collections.title,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            floatingActionButton: _buildFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder(
                stream: controller.service.listenToKoleksis(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final items = snapshot.data;
                    if (items!.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          // Refresh functionality if needed
                        },
                        child: AnimationLimiter(
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final koleksi = items[index];
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                columnCount: 2,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child:
                                        _buildCollectionCard(koleksi, context),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  }
                  return _buildLoadingState();
                },
              ),
            ),
          );
        });
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cornFlower.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        backgroundColor: cornFlower,
        foregroundColor: Colors.white,
        elevation: 0,
        onPressed: () {
          Get.dialog(
            AddKoleksiDialog(
              onCollectionCreated: (collectionName) async {
                await controller.simpanKoleksi(collectionName);
              },
            ),
            barrierDismissible: false,
          );
        },
        icon: const Icon(Icons.add, size: 24),
        label: Text(
          t.collections.create_new,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCollectionCard(koleksi, BuildContext context) {
    return Hero(
      tag: 'collection-${koleksi.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              Routes.KOLEKSI_GAMBAR,
              arguments: koleksi,
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getRandomGradientColor(koleksi.id.hashCode)
                      .withValues(alpha: 0.9),
                  _getRandomGradientColor(koleksi.id.hashCode + 1)
                      .withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -10,
                  top: -10,
                  child: Icon(
                    Icons.collections_bookmark_outlined,
                    size: 100,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      // Collection count
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${koleksi.gambars.length} ${koleksi.gambars.length == 1 ? 'item' : 'items'}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Collection title
                      Text(
                        koleksi.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // View more indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRandomGradientColor(int seed) {
    final colors = [
      const Color(0xFF667EEA), // Indigo
      const Color(0xFF764BA2), // Purple
      const Color(0xFFF093FB), // Pink
      const Color(0xFF4FACFE), // Blue
      const Color(0xFF43E97B), // Green
      const Color(0xFFFA709A), // Coral
      const Color(0xFFFEE140), // Yellow
      const Color(0xFF30CFD0), // Teal
    ];
    return colors[seed.abs() % colors.length];
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Retry functionality
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cornFlower,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: cornFlower.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.collections_bookmark_outlined,
              size: 60,
              color: cornFlower,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            t.collections.empty,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first collection to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.dialog(
                AddKoleksiDialog(
                  onCollectionCreated: (collectionName) async {
                    await controller.simpanKoleksi(collectionName);
                  },
                ),
                barrierDismissible: false,
              );
            },
            icon: const Icon(Icons.add),
            label: Text(t.collections.create_new),
            style: ElevatedButton.styleFrom(
              backgroundColor: cornFlower,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(cornFlower),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading collections...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for animations
class AnimationConfiguration {
  static Widget staggeredGrid({
    required int position,
    required Duration duration,
    required int columnCount,
    required Widget child,
  }) {
    return child;
  }
}

class ScaleAnimation extends StatelessWidget {
  final Widget child;

  const ScaleAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 375),
      curve: Curves.easeOut,
      child: child,
    );
  }
}

class FadeInAnimation extends StatelessWidget {
  final Widget child;

  const FadeInAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 375),
      curve: Curves.easeOut,
      child: child,
    );
  }
}

class AnimationLimiter extends StatelessWidget {
  final Widget child;

  const AnimationLimiter({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
