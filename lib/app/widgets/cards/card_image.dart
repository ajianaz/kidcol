import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kidcol/app/utils/api_config.dart';
import 'package:kidcol/i18n/translations.g.dart';

class CardImage extends StatelessWidget {
  const CardImage({super.key, required this.imageUrl});

  final String? imageUrl;

  /// Validates and processes the image URL
  String? _processImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      debugPrint('CardImage: Empty or null URL provided');
      return null;
    }

    // Remove any leading/trailing whitespace
    url = url.trim();

    // Use ApiConfig to properly format the URL
    final processedUrl = ApiConfig.getImageUrl(url);
    debugPrint('CardImage: Processed URL from $url to $processedUrl');

    return processedUrl.isNotEmpty ? processedUrl : null;
  }

  @override
  Widget build(BuildContext context) {
    final processedUrl = _processImageUrl(imageUrl);

    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(11.5), // Slightly smaller than container
        child: processedUrl != null
            ? CachedNetworkImage(
                imageUrl: processedUrl,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    strokeWidth: 2.0,
                  ),
                ),
                errorWidget: (context, url, error) {
                  debugPrint('CardImage: Failed to load image: $url');
                  debugPrint('CardImage: Error details: $error');
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        SizedBox(height: 4),
                        Text(
                          t.error.failed_to_load_images,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                fadeInDuration: Duration(milliseconds: 300),
                fit:
                    BoxFit.cover, // Changed to cover for better grid appearance
                width: double.infinity,
                height: double.infinity,
                memCacheWidth: 300, // Optimize memory usage
                memCacheHeight: 300,
              )
            : Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                    SizedBox(height: 4),
                    Text(
                      t.images.empty,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
