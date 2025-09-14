import 'package:flutter/material.dart';
import 'package:pool_calculator/core/constants.dart';

class TogglePills<T> extends StatelessWidget {
  final List<T> values;                 // e.g., [Sanitizer.chlorine, ...]
  final T selected;                     // current selection
  final ValueChanged<T> onChanged;      // callback when tapped
  final String Function(T) labelOf;     // maps value -> text label
  final double spacing;                 // gap between pills
  final double minHeight;               // pill height
  final EdgeInsetsGeometry padding;     // inner padding

  const TogglePills({
    super.key,
    required this.values,
    required this.selected,
    required this.onChanged,
    required this.labelOf,
    this.spacing = 8,
    this.minHeight = 48,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      children.add(Expanded(child: _Pill(
        selected: v == selected,
        text: labelOf(v),
        onTap: () => onChanged(v),
        minHeight: minHeight,
        padding: padding,
      )));
      if (i != values.length - 1) children.add(SizedBox(width: spacing));
    }

    return SizedBox(
      width: double.infinity, // full row width
      child: Row(children: children),
    );
  }
}

class _Pill extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onTap;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  const _Pill({
    required this.selected,
    required this.text,
    required this.onTap,
    required this.minHeight,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final child = FittedBox( // keeps long labels like "Salt (SWG)" tidy
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1),
    );

    return selected
        ? FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: Size(0, minHeight),
              padding: padding,
              foregroundColor: AppColors.textColor,
            ),
            child: child,
          )
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: Size(0, minHeight),
              padding: padding,
              foregroundColor: AppColors.textColor,
            ),
            child: child,
          );
  }
}
