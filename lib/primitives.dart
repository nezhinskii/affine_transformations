import 'dart:ui';

sealed class Primitive{
  bool isSelected = false;
}

class Point extends Primitive{
  Offset position;
  Point(this.position);
}

class Line extends Primitive{
  Offset startPosition;
  Offset endPosition;
  Line(this.startPosition, this.endPosition);
}

class Polygon extends Primitive{
  List<Offset> vertexes;
  Polygon(this.vertexes);
}