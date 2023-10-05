import 'dart:ui';

import 'package:affine_transformations/primitives.dart';

enum RelativePointPosition{
  left, right,
}

RelativePointPosition pointRelativeToLine(Point point, Line line){
  final b = line.endPosition - line.startPosition;
  final a = point.position - line.startPosition;
  final sa = a.dx * b.dy - b.dx * a.dy;
  if (sa > 0) {
    return RelativePointPosition.left;
  }
  return RelativePointPosition.right;
}
