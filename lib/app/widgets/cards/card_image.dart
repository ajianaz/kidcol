import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  const CardImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
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
        child: CachedNetworkImage(
          imageUrl: imageUrl.toString(),
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
              strokeWidth: 2.0,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.error_outline,
              color: Colors.grey[400],
            ),
          ),
          fadeInDuration: Duration(milliseconds: 300),
          fit: BoxFit.cover, // Changed to cover for better grid appearance
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
