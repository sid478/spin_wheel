import 'package:flutter/material.dart';

class SpinItem<T> {
  const SpinItem({
    required this.label,
    this.id,
    this.value,
    this.image,
    this.backgroundColor,
    this.backgroundGradient,
    this.textColor,
    this.textStyle,
    this.weight = 1,
  });

  final String label;
  final dynamic id;

  /// Business value returned to the host application.
  final T? value;

  /// Optional image displayed inside the segment.
  final ImageProvider? image;

  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? textColor;
  final TextStyle? textStyle;

  /// Useful if you later add package-level weighted random selection.
  final double weight;

  SpinItem<T> copyWith({
    String? label,
    dynamic id,
    T? value,
    ImageProvider? image,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? textColor,
    TextStyle? textStyle,
    double? weight,
  }) {
    return SpinItem<T>(
      label: label ?? this.label,
      id: id ?? this.id,
      value: value ?? this.value,
      image: image ?? this.image,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      textColor: textColor ?? this.textColor,
      textStyle: textStyle ?? this.textStyle,
      weight: weight ?? this.weight,
    );
  }
}
