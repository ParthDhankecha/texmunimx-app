import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// A placeholder asset URL for demonstration. In a real app,
// you would use a local image asset (e.g., 'assets/placeholder.png')
const String _placeholderAssetUrl = 'assets/images/logo_tr.png';

/// A reusable widget to load and display cached network images.
/// It handles loading state, error state, and provides a default placeholder
/// when the URL is null or empty.
class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  // Widget displayed when the image URL is null or empty, or on failure.
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Use card color for contrast
        borderRadius: borderRadius,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          _placeholderAssetUrl,
          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Check if the URL is null or empty first
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(context);
    }

    // 2. Use CachedNetworkImage for loading, caching, and state handling
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: fit,

        // Placeholder for loading state (Circular Progress)
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          color: Theme.of(context).cardColor,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            // Use the primary color for the loader
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 2,
          ),
        ),

        // Widget to display if loading fails (Error state)
        errorWidget: (context, url, error) {
          // You can log the error here if needed: log('Image load error: $error');
          return _buildPlaceholder(context);
        },
      ),
    );
  }
}
