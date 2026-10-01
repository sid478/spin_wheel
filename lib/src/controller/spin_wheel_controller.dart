import 'dart:async';

import 'package:flutter/foundation.dart';

class SpinWheelController extends ChangeNotifier {
  SpinWheelController({
    int? maxSpins,
  }) : _maxSpins = maxSpins ?? 0;

  int _maxSpins;
  
  int get maxSpins => _maxSpins;
  
  set maxSpins(int? value) {
    final newValue = value ?? 0;
    if (_maxSpins != newValue) {
      _maxSpins = newValue;
      notifyListeners();
    }
  }

  int _spinCount = 0;
  bool _isSpinning = false;

  int get spinCount => _spinCount;
  int get remainingSpins =>
      (_maxSpins - _spinCount).clamp(0, _maxSpins);
  bool get isSpinning => _isSpinning;
  bool get canSpin =>
      !_isSpinning && _spinCount < _maxSpins;

  void _setSpinning(bool value) {
    _isSpinning = value;
    notifyListeners();
  }

  bool _registerSpin() {
    if (!canSpin) return false;
    _spinCount++;
    _setSpinning(true);
    return true;
  }

  void _finishSpin() {
    _setSpinning(false);
  }

  /// Starts a spin.
  ///
  /// The widget consumes [targetIndex] or [targetId] and animates to that segment.
  /// The package does not randomly choose a reward.
  Future<bool> spin({int? targetIndex, dynamic targetId}) async {
    if (!_registerSpin()) return false;

    // The widget attaches a listener to this request.
    _pendingTargetIndex = targetIndex;
    _pendingTargetId = targetId;
    _requestId++;
    notifyListeners();

    final completer = Completer<bool>();
    _pendingCompleter = completer;
    return completer.future;
  }

  int? _pendingTargetIndex;
  dynamic _pendingTargetId;
  int _requestId = 0;
  Completer<bool>? _pendingCompleter;

  int get requestId => _requestId;
  int? consumeTargetIndex() => _pendingTargetIndex;
  dynamic consumeTargetId() => _pendingTargetId;

  Future<void> complete({required bool success}) async {
    _finishSpin();
    final completer = _pendingCompleter;
    _pendingCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(success);
    }
  }

  void resetSpins() {
    _spinCount = 0;
    notifyListeners();
  }

  bool _shouldReset = false;
  bool consumeReset() {
    if (_shouldReset) {
      _shouldReset = false;
      return true;
    }
    return false;
  }

  /// Visually resets the wheel to its starting position without clearing the spin count.
  void resetWheel() {
    _shouldReset = true;
    notifyListeners();
  }

  /// Allows the host app to reset the state after changing campaigns.
  void reset() {
    _spinCount = 0;
    _isSpinning = false;
    _pendingTargetIndex = null;
    _pendingTargetId = null;
    _pendingCompleter = null;
    _shouldReset = true;
    notifyListeners();
  }
}
