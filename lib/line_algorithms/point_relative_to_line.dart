import 'dart:ui';

import 'package:affine_transformations/primitives.dart';

enum RelativePointPosition {
  left,
  right,
  collinear,
}

RelativePointPosition pointRelativeToLine(Point point, Line line) {
  var start = line.startPosition;
  var end = line.endPosition;
  if (start.dy < end.dy) (start, end) = (end, start);

  final b = end - start;
  final a = point.position - start;
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
