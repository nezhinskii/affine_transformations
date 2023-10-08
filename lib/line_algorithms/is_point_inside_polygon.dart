import 'dart:ui';

import 'package:affine_transformations/primitives.dart';
import 'package:affine_transformations/line_algorithms/point_relative_to_line.dart';

bool isPointInsidePolygon(Point point, Polygon polygon) {
  bool res = false;
  for (int i = 0; i < polygon.vertices.length; i++) {
    Offset minPoint = polygon.vertices[i];
    Offset maxPoint = polygon.vertices[(i + 1) % polygon.vertices.length];
    if (minPoint.dy > maxPoint.dy) (minPoint, maxPoint) = (maxPoint, minPoint);

    if (maxPoint.dy <= point.position.dy || minPoint.dy > point.position.dy)
      continue;

    switch (pointRelativeToLineAsOffsets(point.position, minPoint, maxPoint)) {
      case RelativePointPosition.collinear:
        return true;
      case RelativePointPosition.left:
        res != res;
        break;
      default:
    }
  }

  return res;
}
