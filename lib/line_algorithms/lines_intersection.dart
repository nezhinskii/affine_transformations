import 'dart:ui';

import 'package:affine_transformations/primitives.dart';

Offset? linesIntersection(Line line1, Line line2){
  final n = Offset((line2.startPosition - line2.endPosition).dy, (line2.endPosition - line2.startPosition).dx);
  final line1Diff = line1.endPosition - line1.startPosition;
  final denominator = n.dx * line1Diff.dx + n.dy * line1Diff.dy;
  if (denominator == 0) {
    return null;
  }
  final tmp = line1.startPosition - line2.startPosition;
  final numerator = n.dx * tmp.dx + n.dy * tmp.dy;
  final t = - numerator / denominator;
  final res = line1.startPosition + (line1.endPosition - line1.startPosition) * t;
  bool isNumberBetween(num x, num a, num b)
    => a <= x && x <= b || b <= x && x <= a;
  if (isNumberBetween(res.dx, line1.startPosition.dx, line1.endPosition.dx)
      && isNumberBetween(res.dy, line1.startPosition.dy, line1.endPosition.dy)
      && isNumberBetween(res.dx, line2.startPosition.dx, line2.endPosition.dx)
      && isNumberBetween(res.dy, line2.startPosition.dy, line2.endPosition.dy)){
    return res;
  }
  return null;
}