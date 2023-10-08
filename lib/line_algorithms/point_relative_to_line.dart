import 'dart:ui';

import 'package:affine_transformations/primitives.dart';

enum RelativePointPosition {
  left,
  right,
  collinear,
}

RelativePointPosition pointRelativeToLine(Point point, Line line) {
  final b = line.endPosition - line.startPosition;
  final a = point.position - line.startPosition;
  final sa = a.dx * b.dy - b.dx * a.dy;

  return sa == 0
      ? RelativePointPosition.collinear
      : sa > 0
          ? RelativePointPosition.left
          : RelativePointPosition.right;
}

RelativePointPosition pointRelativeToLineAsOffsets(
    Offset point, Offset minPoint, Offset maxPoint) {
  final b = maxPoint - minPoint;
  final a = point - minPoint;
  final sa = a.dx * b.dy - b.dx * a.dy;

  return sa == 0
      ? RelativePointPosition.collinear
      : sa > 0
          ? RelativePointPosition.left
          : RelativePointPosition.right;
}
