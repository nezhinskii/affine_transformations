import 'dart:ui';

import 'package:affine_transformations/primitives.dart';
import 'package:flutter/material.dart';

class PrimitivesPainter extends CustomPainter{
  final List<Primitive> primitives;
  final Paint style;
  final List<Offset>? newPoints;

  const PrimitivesPainter({
    required this.primitives,
    required this.style,
    this.newPoints
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var primitive in primitives){
      var paint = Paint()..strokeWidth = style.strokeWidth..color = style.color;
      if (primitive.isSelected){
        paint.color = Colors.red;
      }
      switch (primitive){
        case Point():
          canvas.drawPoints(PointMode.points, [primitive.position], paint);
        case Line():
          canvas.drawLine(primitive.startPosition, primitive.endPosition, paint);
        case Polygon():
          for(int i = 1; i < primitive.vertexes.length; ++i){
            canvas.drawLine(primitive.vertexes[i - 1], primitive.vertexes[i], paint);
          }
          canvas.drawLine(primitive.vertexes.first, primitive.vertexes.last, paint);
      }
    }
    if (newPoints != null) {
      if (newPoints!.length == 1){
        canvas.drawPoints(PointMode.points, [newPoints!.first], style);
      }
      for(int i = 1; i < newPoints!.length; ++i){
        canvas.drawLine(newPoints![i - 1], newPoints![i], style);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}