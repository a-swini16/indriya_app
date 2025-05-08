// lib/utils/responsive_helper.dart
import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  static double getWidth(BuildContext context, {double percentage = 1.0}) {
    return MediaQuery.of(context).size.width * percentage;
  }

  static double getHeight(BuildContext context, {double percentage = 1.0}) {
    return MediaQuery.of(context).size.height * percentage;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 32);
    }
  }

  static double getResponsiveValue({
    required BuildContext context,
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }

  static int getResponsiveGridCount(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }

  static SizedBox contentContainer(
    Widget child, {
    double maxWidth = 1200,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return SizedBox(
      width: maxWidth,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
