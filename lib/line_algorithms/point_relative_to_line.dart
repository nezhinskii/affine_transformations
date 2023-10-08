import 'dart:ui';

import 'package:affine_transformations/primitives.dart';

enum RelativePointPosition {
  left,
  right,
  within,
}

RelativePointPosition pointRelativeToLine(Point point, Line line) {
  final b = line.endPosition - line.startPosition;
  final a = point.position - line.startPosition;
  final sa = a.dx * b.dy - b.dx * a.dy;

  return sa == 0
      ? RelativePointPosition.within
      : sa > 0
          ? RelativePointPosition.left
          : RelativePointPosition.right;
}

RelativePointPosition pointRelativeToLineAsOffsets(
    Offset point, Offset linePoint1, Offset linePoint2) {
  final b = linePoint2 - linePoint1;
  final a = point - linePoint1;
  final sa = a.dx * b.dy - b.dx * a.dy;

  return sa == 0
      ? RelativePointPosition.within
      : sa > 0
          ? RelativePointPosition.left
          : RelativePointPosition.right;
}
