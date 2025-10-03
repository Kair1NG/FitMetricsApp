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
    final ColorScheme colorScheme = Theme.of(this).colorScheme;

    return Card(
      elevation: 5,
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(16),
        width: double.infinity,
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
    final ColorScheme colorScheme = Theme.of(this).colorScheme;

    return Container(
      padding: padding ?? EdgeInsets.all(20),
      margin: margin ?? EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Now accepts optional child and onPressed
  /// If no child provided, returns a default ElevatedButton so existing
  /// calls like `context.styledElevatedButton().style` continue to work also
  ElevatedButton styledElevatedButton({
    Widget? child,
    VoidCallback? onPressed,
    ButtonStyle? style,
  }) {
    final ColorScheme colorScheme = Theme.of(this).colorScheme;
    final ButtonStyle resolvedStyle =
        style ??
        ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        );

    return ElevatedButton(
      style: resolvedStyle,
      onPressed: onPressed ?? () {},
      child: child ?? const Text('Styled Button'),
    );
  }
}
