import 'dart:ui';

sealed class Primitive {
  Primitive(this.vertices);

  List<Offset> vertices;
  bool isSelected = false;

}

class Point extends Primitive {
  Offset get position => vertices[0];

  Point(Offset position) : super([position]);
}

class Line extends Primitive {
  Offset get startPosition => vertices[0];
  Offset get endPosition => vertices[1];

  Line(Offset startPosition, Offset endPosition)
      : super([
          startPosition,
          endPosition,
        ]);
}

class Polygon extends Primitive {
  Polygon(super.vertices);
}
