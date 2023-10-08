part of 'main_bloc.dart';

sealed class MainEvent {
  const MainEvent();
}

class StartPrimitiveAdding extends MainEvent {
  const StartPrimitiveAdding();
}

class AddPointEvent extends MainEvent {
  final Offset point;
  const AddPointEvent(this.point);
}

class EndPrimitiveAdding extends MainEvent {
  const EndPrimitiveAdding();
}

class ClearCanvasEvent extends MainEvent {
  const ClearCanvasEvent();
}

class PrimitiveSelectedChanged extends MainEvent {
  final int index;
  const PrimitiveSelectedChanged(this.index);
}

class RemovePrimitive extends MainEvent {
  final int index;
  const RemovePrimitive(this.index);
}

class LinesIntersectionEvent extends MainEvent {}

class PointRelativeToLineEvent extends MainEvent {}

class IsPointInsidePolygonEvent extends MainEvent {}
