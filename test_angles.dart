import 'dart:math' as math;

void main() {
  int itemsLength = 6;
  int index = 1;
  double segment = 2 * math.pi / itemsLength;
  double targetAngle = -(index * segment + segment / 2);
  
  print("targetAngle: ${targetAngle * 180 / math.pi}");
  
  double rotation = targetAngle;
  for (int i = 0; i < itemsLength; i++) {
    double start = rotation - math.pi / 2 + i * segment;
    double center = start + segment / 2;
    // Normalize to [0, 360)
    double centerDeg = (center * 180 / math.pi) % 360;
    if (centerDeg < 0) centerDeg += 360;
    print("Item $i center: $centerDeg");
  }
}
