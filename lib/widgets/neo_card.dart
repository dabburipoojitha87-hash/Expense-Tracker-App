import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const NeoCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppTheme.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.black, width: 2),
      ),
      child: child,
    );
  }
}
