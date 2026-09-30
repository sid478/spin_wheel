import 'package:flutter/material.dart';

class SpinWheelTheme {
  const SpinWheelTheme({
    this.colors = const [
      Color(0xFFFFC107),
      Color(0xFF4FC3F7),
      Color(0xFFE91E63),
      Color(0xFF039BE5),
      Color(0xFFF48FB1),
      Color(0xFFF44336),
    ],
    this.segmentGradients = const [
      RadialGradient(colors: [Color(0xFFFFF176), Color(0xFFF57F17)]), // Golden
      RadialGradient(colors: [Color(0xFF69F0AE), Color(0xFF00A152)]), // Emerald
      RadialGradient(colors: [Color(0xFF40C4FF), Color(0xFF0064B7)]), // Azure
      RadialGradient(colors: [Color(0xFFFF80AB), Color(0xFFC51162)]), // Hot Pink
      RadialGradient(colors: [Color(0xFFEA80FC), Color(0xFF8E24AA)]), // Magenta
      RadialGradient(colors: [Color(0xFFFF9E80), Color(0xFFD84315)]),
    ],
    this.dividerColor = Colors.white,
    this.dividerWidth = 2,
    this.outerRingColor = const Color(0xFF0B4EA2),
    this.outerRingGradient = const SweepGradient(
      colors: [
        Color(0xFF4FC3F7),
        Color(0xFF01579B),
      ],
    ),
    // [  Color(0xFF4FC3F7), Color(0xFF01579B),],
    this.outerRingWidth = 24,
    this.centerColor = const Color(0xFF0755B8),
    this.centerBorderColor = Colors.white,
    this.centerBorderWidth = 2,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
  });

  final List<Color> colors;
  final List<Gradient>? segmentGradients;
  final Color dividerColor;
  final double dividerWidth;

  final Color outerRingColor;
  final Gradient? outerRingGradient;
  final double outerRingWidth;

  final Color centerColor;
  final Color centerBorderColor;
  final double centerBorderWidth;

  final TextStyle textStyle;
}
