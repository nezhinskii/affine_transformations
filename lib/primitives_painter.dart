import 'dart:ui';

import 'package:affine_transformations/primitives.dart';
import 'package:flutter/material.dart';

class PrimitivesPainter extends CustomPainter{
  final List<Primitive> primitives;
  final Paint style;
  final List<Offset>? newPoints;
  final Set<int> selectedPrimitivesIndexes;

  const PrimitivesPainter({
    required this.primitives,
    required this.style,
    required this.selectedPrimitivesIndexes,
    this.newPoints
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < primitives.length; ++i){
      var paint = Paint()..strokeWidth = style.strokeWidth..color = style.color;
      if (selectedPrimitivesIndexes.contains(i)){
        paint.color = Colors.red;
      }
      final primitive = primitives[i];
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