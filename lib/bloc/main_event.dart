part of 'main_bloc.dart';

sealed class MainEvent{
  const MainEvent();
}

class StartPrimitiveAdding extends MainEvent{
  const StartPrimitiveAdding();
}

class AddPointEvent extends MainEvent{
  final Offset point;
  const AddPointEvent(this.point);
}

class EndPrimitiveAdding extends MainEvent{
  const EndPrimitiveAdding();
}

class ClearCanvasEvent extends MainEvent{
  const ClearCanvasEvent();
}

class SelectPrimitive extends MainEvent{
  final int index;
  const SelectPrimitive(this.index);
}

class UnselectPrimitive extends MainEvent{
  final int index;
  const UnselectPrimitive(this.index);
}