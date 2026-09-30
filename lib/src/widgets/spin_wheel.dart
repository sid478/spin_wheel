import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../controller/spin_wheel_controller.dart';
import '../models/spin_item.dart';
import '../theme/spin_wheel_theme.dart';
import 'spin_wheel_marker.dart';
import 'winner_overlay.dart';

typedef WinnerOverlayBuilder<T> = Widget Function(
  BuildContext context,
  SpinItem<T> item,
  int index,
);

enum SpinWheelOuterRingDecoration {
  bulb,
  star,
  semicircle,
}

class SpinWheel<T> extends StatefulWidget {
  const SpinWheel({
    super.key,
    required this.items,
    this.controller,
    this.maxSpinCount,
    this.theme = const SpinWheelTheme(),
    this.marker = const SpinWheelMarker(),
    this.markerSize = 62,
    this.wheelSize,
    this.spinDuration = const Duration(seconds: 5),
    this.minimumTurns = 5,
    this.showCenterButton = true,
    this.centerBuilder,
    this.showConfetti = true,
    this.showWinnerPopup = true,
    this.winnerPopupTitle = 'Congratulations!',
    this.winnerPopupButtonText = 'Continue',
    this.onWinnerPopupButtonTap,
    this.winnerPopupBuilder,
    this.showSpinCount = true,
    this.showSpinButton = true,
    this.spinButtonText = 'SPIN',
    this.spinButtonTextStyle,
    this.spinButtonStyle,
    this.spinButtonColor,
    this.spinButtonWidth,
    this.spinButtonHeight,
    this.spinButtonBorderRadius = 24.0,
    this.onSpinButtonTap,
    this.spinCountBuilder,
    this.spinButtonBuilder,
    this.playSpinSound,
    this.playWinSound,
    this.onSpinStart,
    this.onWinner,
    this.onSpinEnd,
    this.autoSpinOnTap = true,
    this.enableTapToSpin = true,
    this.outerRingDecoration = SpinWheelOuterRingDecoration.bulb,
    this.outerSemiCircleCount = 18,
    this.showOuterSemiCircle = true,
    this.showDividers = true,
    this.imageSizeFactor = .22,
    this.textRadiusFactor = .64,
  }) : assert(items.length >= 2, 'SpinWheel requires at least 2 items.');

  final List<SpinItem<T>> items;
  final SpinWheelController? controller;
  final int? maxSpinCount;
  final SpinWheelTheme theme;
  final Widget marker;
  final double markerSize;

  final double? wheelSize;
  final Duration spinDuration;
  final int minimumTurns;

  final bool showCenterButton;
  final Widget? centerBuilder;

  final bool showConfetti;
  final bool showWinnerPopup;
  final String winnerPopupTitle;
  final String winnerPopupButtonText;
  final void Function(SpinItem<T> item, int index)? onWinnerPopupButtonTap;
  final WinnerOverlayBuilder<T>? winnerPopupBuilder;

  final bool showSpinCount;
  final bool showSpinButton;
  final String spinButtonText;
  final TextStyle? spinButtonTextStyle;
  final ButtonStyle? spinButtonStyle;
  final Color? spinButtonColor;
  final double? spinButtonWidth;
  final double? spinButtonHeight;
  final double spinButtonBorderRadius;
  
  /// Callback when the spin button is tapped. 
  /// Return the target index or id you want the wheel to stop at (e.g., from an API response).
  final FutureOr<dynamic> Function()? onSpinButtonTap;
  
  final Widget Function(BuildContext context, SpinWheelController controller)? spinCountBuilder;
  final Widget Function(BuildContext context, SpinWheelController controller)? spinButtonBuilder;

  final VoidCallback? playSpinSound;
  final VoidCallback? playWinSound;
  final VoidCallback? onSpinStart;
  final void Function(SpinItem<T> item, int index)? onWinner;
  final void Function(SpinItem<T> item, int index)? onSpinEnd;

  final bool autoSpinOnTap;
  final bool enableTapToSpin;

  final SpinWheelOuterRingDecoration outerRingDecoration;
  final int outerSemiCircleCount;
  final bool showOuterSemiCircle;
  final bool showDividers;

  final double imageSizeFactor;
  final double textRadiusFactor;

  @override
  State<SpinWheel<T>> createState() => _SpinWheelState<T>();
}

class _SpinWheelState<T> extends State<SpinWheel<T>>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  ConfettiController? _confettiController;
  SpinWheelController? _controller;
  double _rotation = 0;
  int _lastRequestId = 0;

  late final AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.spinDuration,
    );
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    if (widget.showConfetti) {
      _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    }
    _attachController();
  }

  @override
  void didUpdateWidget(covariant SpinWheel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController();
    } else if (oldWidget.maxSpinCount != widget.maxSpinCount) {
      if (widget.controller != null) {
        widget.controller!.maxSpins = widget.maxSpinCount;
      }
    }
  }

  void _attachController() {
    _controller = widget.controller ?? SpinWheelController(maxSpins: widget.maxSpinCount);
    if (widget.controller != null && widget.controller!.maxSpins == null) {
      widget.controller!.maxSpins = widget.maxSpinCount;
    }
    _controller!.addListener(_onControllerChanged);
  }

  void _detachController() {
    _controller?.removeListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final controller = _controller;
    if (controller == null) return;
    
    if (controller.consumeReset()) {
      if (mounted) {
        _animationController.reset();
        _confettiController?.stop();
        setState(() {
          _rotation = 0;
        });
      }
      return;
    }

    if (controller.requestId == _lastRequestId) return;

    _lastRequestId = controller.requestId;
    
    int? resolvedIndex = controller.consumeTargetIndex();
    final targetId = controller.consumeTargetId();
    
    if (targetId != null) {
      final indexFromId = widget.items.indexWhere((item) => item.id == targetId);
      if (indexFromId != -1) {
        resolvedIndex = indexFromId;
      } else {
        final betterLuckIndex = widget.items.indexWhere(
            (item) => item.label.toLowerCase().contains('better'));
        if (betterLuckIndex != -1) {
          resolvedIndex = betterLuckIndex;
        }
      }
    }

    if (!mounted) return;
    _startSpin(targetIndex: resolvedIndex);
  }

  Future<void> _startSpin({int? targetIndex}) async {
    final controller = _controller;
    if (controller == null || widget.items.length < 2) return;

    final index = (targetIndex ?? 0).clamp(0, widget.items.length - 1);
    final count = widget.items.length;
    final segment = 2 * math.pi / count;

    // Pointer is at the top. Put the selected segment center under it.
    final targetAngle = -(index * segment + segment / 2);

    var current = _rotation % (2 * math.pi);
    var delta = targetAngle - current;

    while (delta <= 0) {
      delta += 2 * math.pi;
    }

    final total = widget.minimumTurns * 2 * math.pi + delta;
    final begin = _rotation;
    final end = _rotation + total;

    widget.onSpinStart?.call();
    widget.playSpinSound?.call();

    _animationController.duration = widget.spinDuration;
    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _animationController.reset();

    void listener() {
      setState(() {
        _rotation = begin + (end - begin) * animation.value;
      });
    }

    animation.addListener(listener);

    try {
      await _animationController.forward();
    } finally {
      animation.removeListener(listener);
    }

    _rotation %= 2 * math.pi;

    final item = widget.items[index];
    widget.playWinSound?.call();
    widget.onWinner?.call(item, index);
    widget.onSpinEnd?.call(item, index);

    final isBetterLuck = item.label.toLowerCase().contains('better');
    if (mounted && widget.showConfetti && !isBetterLuck) {
      _confettiController?.play();
    }

    if (mounted && widget.showWinnerPopup) {
      await _showWinner(item, index);
    }

    await controller.complete(success: true);
  }

  Future<void> _showWinner(SpinItem<T> item, int index) async {
    if (!mounted) return;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Winner',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return winnerPopupBuilder(
          context,
          item,
          index,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: .8, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget winnerPopupBuilder(
    BuildContext context,
    SpinItem<T> item,
    int index,
  ) {
    final isBetterLuck = item.label.toLowerCase().contains('better');
    
    return widget.winnerPopupBuilder?.call(context, item, index) ??
        DefaultWinnerOverlay<T>(
          item: item,
          index: index,
          title: isBetterLuck ? 'Oops!' : widget.winnerPopupTitle,
          icon: isBetterLuck ? Icons.sentiment_dissatisfied_rounded : Icons.celebration_rounded,
          buttonText: widget.winnerPopupButtonText,
          onButtonTap: widget.onWinnerPopupButtonTap == null
              ? null
              : () => widget.onWinnerPopupButtonTap!(item, index),
        );
  }

  void _handleTap() {
    if (!widget.enableTapToSpin || !widget.autoSpinOnTap) return;
    _controller?.spin(targetIndex: _defaultTargetIndex());
  }

  int _defaultTargetIndex() {
    // For demo use only. Production reward flows should pass the backend result.
    return math.Random().nextInt(widget.items.length);
  }

  @override
  void dispose() {
    _detachController();
    _animationController.dispose();
    _blinkController.dispose();
    _confettiController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.wheelSize ?? 340;

    final wheel = GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: size,
        height: size + widget.markerSize * .45,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _SpinWheelPainter<T>(
                  items: widget.items,
                  theme: widget.theme,
                  rotation: _rotation,
                  showDividers: widget.showDividers,
                  showOuterSemiCircleRing: widget.showOuterSemiCircle,
                  outerSemiCircleCount: widget.outerSemiCircleCount,
                  outerRingDecoration: widget.outerRingDecoration,
                  blinkAnimation: _blinkController,
                  imageSizeFactor: widget.imageSizeFactor,
                  textRadiusFactor: widget.textRadiusFactor,
                ),
                child: Center(
                  child: widget.showCenterButton
                      ? (widget.centerBuilder ??
                          _DefaultCenter(
                            color: widget.theme.centerColor,
                            borderColor: widget.theme.centerBorderColor,
                            borderWidth: widget.theme.centerBorderWidth,
                          ))
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned(
              top: -widget.markerSize * .10,
              child: widget.marker,
            ),
          ],
        ),
      ),
    );

    Widget content;
    if (!widget.showSpinCount && !widget.showSpinButton) {
      content = wheel;
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          wheel,
        if (widget.showSpinCount) ...[
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) {
              if (widget.spinCountBuilder != null) {
                return widget.spinCountBuilder!(context, _controller!);
              }
              return Text(
                'Spins: ${_controller!.spinCount} / ${_controller!.maxSpins}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
        ],
        if (widget.showSpinButton) ...[
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) {
              if (widget.spinButtonBuilder != null) {
                return widget.spinButtonBuilder!(context, _controller!);
              }
              return SizedBox(
                width: widget.spinButtonWidth,
                height: widget.spinButtonHeight,
                child: FilledButton(
                  style: widget.spinButtonStyle ??
                      FilledButton.styleFrom(
                        backgroundColor: widget.spinButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widget.spinButtonBorderRadius),
                        ),
                      ),
                  onPressed: _controller!.canSpin
                      ? () async {
                          if (widget.onSpinButtonTap != null) {
                              try {
                                final result = await widget.onSpinButtonTap!();
                                _controller!.spin(targetId: result);
                              } catch (e) {
                              // If the user's Future throws (e.g. API fails), we do nothing.
                            }
                          } else {
                            _handleTap();
                          }
                        }
                      : null,
                  child: Text(
                    widget.spinButtonText,
                    style: widget.spinButtonTextStyle,
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
    }

    if (!widget.showConfetti || _confettiController == null) {
      return content;
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        content,
        ConfettiWidget(
          confettiController: _confettiController!,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
            Colors.cyanAccent,
          ],
        ),
      ],
    );
  }
}

class _DefaultCenter extends StatelessWidget {
  const _DefaultCenter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  final Color color;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black26,
          ),
        ],
      ),
      child: const Icon(
        Icons.star_border_purple500,
        size: 48,
        color: Colors.orange,
      ),
    );
  }
}

class _SpinWheelPainter<T> extends CustomPainter {
  _SpinWheelPainter({
    required this.items,
    required this.theme,
    required this.rotation,
    required this.showDividers,
    required this.showOuterSemiCircleRing,
    required this.outerSemiCircleCount,
    required this.outerRingDecoration,
    required this.blinkAnimation,
    required this.imageSizeFactor,
    required this.textRadiusFactor,
  }) : super(repaint: blinkAnimation);

  final List<SpinItem<T>> items;
  final SpinWheelTheme theme;
  final double rotation;
  final bool showDividers;
  final bool showOuterSemiCircleRing;
  final int outerSemiCircleCount;
  final SpinWheelOuterRingDecoration outerRingDecoration;
  final Animation<double> blinkAnimation;
  final double imageSizeFactor;
  final double textRadiusFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;

    _drawOuterRing(canvas, center, radius);
    _drawSegments(canvas, center, radius);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint();
    if (theme.outerRingGradient != null) {
      ringPaint.shader = theme.outerRingGradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    } else if (theme.outerRingColor != null) {
      ringPaint.color = theme.outerRingColor!;
    } else {
      ringPaint.shader = const SweepGradient(
        colors: [
          Color(0xFF4FC3F7),
          Color(0xFF01579B),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    }

    canvas.drawCircle(
      center,
      radius, // Fixed! It should fill the entire radius to form the full thick border.
      ringPaint,
    );

    if (!showOuterSemiCircleRing || outerSemiCircleCount <= 0) return;

    final lightRadius = math.max(6.0, theme.outerRingWidth * .18);
    final ringRadius = radius - theme.outerRingWidth / 2;

    for (var i = 0; i < outerSemiCircleCount; i++) {
      final angle = i * 2 * math.pi / outerSemiCircleCount;
      final point = Offset(
        center.dx + ringRadius * math.cos(angle),
        center.dy + ringRadius * math.sin(angle),
      );

      // Blinking effect: odd indices blink out of phase with even indices
      final bool isEven = i % 2 == 0;
      final double opacity = isEven 
          ? blinkAnimation.value 
          : 1.0 - blinkAnimation.value;
      
      final lightPaint = Paint()
        ..color = Colors.white.withOpacity(0.3 + (opacity * 0.6));

      if (outerRingDecoration == SpinWheelOuterRingDecoration.bulb) {
        canvas.drawCircle(point, lightRadius, lightPaint);
      } else if (outerRingDecoration == SpinWheelOuterRingDecoration.star) {
        final path = Path();
        const int numPoints = 6;
        final double innerRadius = lightRadius * 0.5;
        double starAngle = -math.pi / 2; // Pointing upwards
        final double step = math.pi / numPoints;

        for (int j = 0; j < numPoints * 2; j++) {
          final double r = (j % 2 == 0) ? lightRadius : innerRadius;
          final double x = point.dx + r * math.cos(starAngle);
          final double y = point.dy + r * math.sin(starAngle);
          if (j == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
          starAngle += step;
        }
        path.close();
        canvas.drawPath(path, lightPaint);
      }
      else {
        // Draw semicircle pointing outwards
        final path = Path();
        path.arcTo(
          Rect.fromCircle(center: point, radius: lightRadius),
          angle - math.pi / 2, // Start angle
          math.pi, // Sweep angle (180 degrees)
          true,
        );
        canvas.drawPath(path, lightPaint);
      }
    }
  }

  void _drawSegments(Canvas canvas, Offset center, double radius) {
    final segmentRadius = radius - theme.outerRingWidth;
    final sweep = 2 * math.pi / items.length;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final start = rotation - math.pi / 2 + i * sweep;

      final fill = Paint()..style = PaintingStyle.fill;
      
      final gradient = item.backgroundGradient ?? 
          (theme.segmentGradients != null && theme.segmentGradients!.isNotEmpty 
              ? theme.segmentGradients![i % theme.segmentGradients!.length] 
              : null);

      if (gradient != null) {
        fill.shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: segmentRadius),
        );
      } else {
        fill.color = item.backgroundColor ?? theme.colors[i % theme.colors.length];
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: segmentRadius),
        start,
        sweep,
        true,
        fill,
      );

      if (showDividers) {
        final divider = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = theme.dividerWidth
          ..color = theme.dividerColor;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: segmentRadius),
          start,
          sweep,
          true,
          divider,
        );
      }

      _drawItem(canvas, center, segmentRadius, item, start, sweep);
    }
  }

  void _drawItem(
    Canvas canvas,
    Offset center,
    double radius,
    SpinItem<T> item,
    double start,
    double sweep,
  ) {
    final angle = start + sweep / 2;
    final textCenter = Offset(
      center.dx + radius * textRadiusFactor * math.cos(angle),
      center.dy + radius * textRadiusFactor * math.sin(angle),
    );

    if (item.image != null) {
      _drawImagePlaceholder(
        canvas,
        textCenter.translate(0, -radius * .10),
        radius * imageSizeFactor,
        item,
      );
    }

    final textStyle = item.textStyle ??
        theme.textStyle.copyWith(
          color: item.textColor ?? theme.textStyle.color,
        );

    final painter = TextPainter(
      text: TextSpan(
        text: item.label,
        style: textStyle,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: radius * .48,
      );

    canvas.save();
    canvas.translate(textCenter.dx, textCenter.dy);
    canvas.rotate(angle + math.pi / 2);
    painter.paint(
      canvas,
      Offset(-painter.width / 2, -painter.height / 2),
    );
    canvas.restore();
  }

  void _drawImagePlaceholder(
    Canvas canvas,
    Offset center,
    double radius,
    SpinItem<T> item,
  ) {
    // CustomPainter cannot synchronously resolve arbitrary ImageProviders.
    // The package intentionally keeps painting synchronous. A production
    // implementation can add an ImageStream cache here.
    final paint = Paint()..color = Colors.white.withValues(alpha: .92);
    canvas.drawCircle(center, radius, paint);

    final iconPaint = Paint()
      ..color = item.textColor ?? Colors.black54
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * .45, iconPaint);
  }

  @override
  bool shouldRepaint(covariant _SpinWheelPainter<T> oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.items != items ||
        oldDelegate.theme != theme ||
        oldDelegate.showDividers != showDividers ||
        oldDelegate.showOuterSemiCircleRing != showOuterSemiCircleRing;
  }
}
