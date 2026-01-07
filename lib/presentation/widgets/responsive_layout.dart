import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/foldable.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? foldableFolded;
  final Widget? foldableUnfolded;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.foldableFolded,
    this.foldableUnfolded,
  });

  @override
  Widget build(BuildContext context) {
    final foldableInfo = FoldableHelper.getFoldableInfo(context);

    // Handle foldable devices
    if (foldableInfo.isFoldable) {
      if (foldableInfo.isFolded) {
        return foldableFolded ?? mobile;
      } else {
        return foldableUnfolded ?? tablet ?? desktop ?? mobile;
      }
    }

    // Handle regular responsive layouts
    if (Responsive.isMobile(context)) {
      return mobile;
    } else if (Responsive.isTablet(context)) {
      return tablet ?? mobile;
    } else if (Responsive.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
          BuildContext context, bool isMobile, bool isTablet, bool isDesktop)
      builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      Responsive.isMobile(context),
      Responsive.isTablet(context),
      Responsive.isDesktop(context),
    );
  }
}

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final maxContentWidth = maxWidth ?? Responsive.getMaxContentWidth(context);
    final contentPadding = padding ?? Responsive.getPadding(context);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        padding: contentPadding,
        child: child,
      ),
    );
  }
}
