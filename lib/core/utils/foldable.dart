import 'package:flutter/material.dart';
import 'responsive.dart';

class FoldableInfo {
  final bool isFoldable;
  final bool isFolded;
  final double foldWidth;
  final double foldHeight;
  final bool hasHinge;

  const FoldableInfo({
    this.isFoldable = false,
    this.isFolded = false,
    this.foldWidth = 0,
    this.foldHeight = 0,
    this.hasHinge = false,
  });

  bool get isTabletopMode => isFoldable && !isFolded;
  bool get isBookMode => isFoldable && isFolded;
}

class FoldableHelper {
  static FoldableInfo getFoldableInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    final width = size.width;
    final height = size.height;

    // Detect foldable based on screen dimensions and aspect ratio
    // Z Fold typically has: folded: 6.2" x 2.6", unfolded: 7.6" x 5.6"
    final isFoldable = _detectFoldable(width, height);

    if (!isFoldable) {
      return const FoldableInfo();
    }

    // Check if device is in folded state
    // Folded: narrower width, unfolded: wider width
    final isFolded = width < 600;

    // Estimate hinge area (typically 1-2% of screen)
    final foldWidth = isFolded ? 0.0 : (width * 0.01);
    final foldHeight = isFolded ? (height * 0.01) : 0.0;

    return FoldableInfo(
      isFoldable: true,
      isFolded: isFolded,
      foldWidth: foldWidth,
      foldHeight: foldHeight,
      hasHinge: !isFolded,
    );
  }

  static bool _detectFoldable(double width, double height) {
    // Z Fold characteristics:
    // - Folded: ~512px width (portrait), ~683px height
    // - Unfolded: ~768px width (portrait), ~1024px height
    // - Aspect ratio changes significantly

    final isPortrait = height > width;

    // Check for foldable-like dimensions
    if (isPortrait) {
      // Portrait mode
      if (width >= 600 && width <= 900 && height >= 1000) {
        return true; // Unfolded
      }
      if (width >= 280 && width <= 400 && height >= 600) {
        return true; // Folded
      }
    } else {
      // Landscape mode
      if (height >= 600 && height <= 900 && width >= 1000) {
        return true; // Unfolded
      }
      if (height >= 280 && height <= 400 && width >= 600) {
        return true; // Folded
      }
    }

    return false;
  }

  static Widget buildFoldableAware(
    BuildContext context, {
    required Widget foldedChild,
    required Widget unfoldedChild,
    Widget? hingeWidget,
  }) {
    final foldableInfo = getFoldableInfo(context);

    if (!foldableInfo.isFoldable) {
      return foldedChild;
    }

    if (foldableInfo.isFolded) {
      return foldedChild;
    }

    // Unfolded state - can use dual pane layout
    if (foldableInfo.hasHinge && hingeWidget != null) {
      return Row(
        children: [
          Expanded(child: unfoldedChild),
          SizedBox(
            width: foldableInfo.foldWidth,
            child: hingeWidget,
          ),
          Expanded(child: unfoldedChild),
        ],
      );
    }

    return unfoldedChild;
  }

  static EdgeInsets getFoldablePadding(BuildContext context) {
    final foldableInfo = getFoldableInfo(context);

    if (!foldableInfo.isFoldable) {
      return Responsive.getPadding(context);
    }

    if (foldableInfo.isFolded) {
      return const EdgeInsets.all(16);
    }

    // Unfolded - more padding for larger screen
    return const EdgeInsets.symmetric(horizontal: 48, vertical: 32);
  }
}
