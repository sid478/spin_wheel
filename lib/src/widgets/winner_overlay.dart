import 'package:flutter/material.dart';

import '../models/spin_item.dart';

class DefaultWinnerOverlay<T> extends StatelessWidget {
  const DefaultWinnerOverlay({
    super.key,
    required this.item,
    required this.index,
    this.title = 'Congratulations!',
    this.buttonText = 'Continue',
    this.icon = Icons.celebration_rounded,
    this.onButtonTap,
  });

  final SpinItem<T> item;
  final int index;
  final String title;
  final String buttonText;
  final IconData icon;
  final VoidCallback? onButtonTap;

  static const Color accentColor = Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 310,
          margin: const EdgeInsets.all(28),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF8D6),
                Color(0xFFFFD54F),
                Color(0xFFFFB300),
                Color(0xFFFF8F00),
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 70,
                color: accentColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(accentColor),
                  foregroundColor:
                  WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                onPressed:
                onButtonTap ?? () => Navigator.of(context).pop(),
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}