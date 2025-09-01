import 'package:flutter/material.dart';

extension ContainerExtensions on BuildContext {
  Widget styledCard({
    required Widget child,
    double? height,
    double? width,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
  }) {
    // final screenHeight = MediaQuery.of(this).size.height;
    final screenWidth = MediaQuery.of(this).size.width;
    final ColorScheme colorScheme = Theme.of(this).colorScheme;

    return Card(
      elevation: 5,
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(16),
        width: width ?? screenWidth * 0.9,
        // height: height ?? screenHeight * 0.1,
        child: child,
      ),
    );
  }

  Widget styledContainer({
    required Widget child,
    double? height,
    double? width,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    //final screenHeight = MediaQuery.of(this).size.height;
    final screenWidth = MediaQuery.of(this).size.width;
    final ColorScheme colorScheme = Theme.of(this).colorScheme;

    return Container(
      padding: padding ?? EdgeInsets.all(20),
      margin: margin ?? EdgeInsets.only(top: 20),
      width: width ?? screenWidth * 0.9,
      //height: height ?? screenHeight * 0.1,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  ElevatedButton styledElevatedButton() {
    final ColorScheme colorScheme = Theme.of(this).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: () {},
      child: Text('Styled Button'),
    );
  }
}
