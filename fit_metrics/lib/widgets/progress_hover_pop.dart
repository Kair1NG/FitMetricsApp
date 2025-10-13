import 'package:flutter/material.dart';

class ProgressHoverPop extends StatefulWidget {
  final Widget child;
  final double scale;
  final double shadowBlur;
  final Duration duration;

  const ProgressHoverPop({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.shadowBlur = 8.0,
    this.duration = const Duration(milliseconds: 180),
  });

  @override
  State<ProgressHoverPop> createState() => _ProgressHoverPopState();
}

class _ProgressHoverPopState extends State<ProgressHoverPop> {
  bool _hovering = false;
  bool _pressed = false;

  void _setHover(bool hovering) => setState(() => _hovering = hovering);

  void _setPressed(bool pressed) => setState(() => _pressed = pressed);

  @override
  Widget build(BuildContext context) {
    final isActive = _hovering || _pressed;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: isActive ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: widget.shadowBlur,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}