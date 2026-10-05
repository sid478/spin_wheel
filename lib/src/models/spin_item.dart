import 'package:flutter/material.dart';

/// A model representing a single segment on the spin wheel.
class SpinItem<T> {
  /// Creates a new [SpinItem].
  const SpinItem({
    required this.label,
    this.id,
    this.value,
    this.image,
    this.imageSize,
    this.backgroundColor,
    this.backgroundGradient,
    this.textColor,
    this.textStyle,
    this.weight = 1,
  });

  /// The text displayed on this segment.
  final String label;
  
  /// An optional unique identifier for this item.
  final dynamic id;

  /// Business value returned to the host application.
  final T? value;

  /// Optional image displayed inside the segment.
  final String? image;

  /// Optional size of the image. Defaults to 40 if not provided.
  final double? imageSize;

  /// The background color for this segment. If null, a theme color is used.
  final Color? backgroundColor;

  /// The background gradient for this segment. Overrides [backgroundColor] if provided.
  final Gradient? backgroundGradient;

  /// The text color for the [label]. If null, a theme color is used.
  final Color? textColor;

  /// The text style for the [label]. Overrides [textColor] if provided.
  final TextStyle? textStyle;

  /// Useful if you later add package-level weighted random selection.
  final double weight;

  SpinItem<T> copyWith({
    String? label,
    dynamic id,
    T? value,
    String? image,
    double? imageSize,
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
      imageSize: imageSize ?? this.imageSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      textColor: textColor ?? this.textColor,
      textStyle: textStyle ?? this.textStyle,
      weight: weight ?? this.weight,
    );
  }
}
