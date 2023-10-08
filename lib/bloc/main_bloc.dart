import 'dart:ui';

import 'package:affine_transformations/line_algorithms/lines_intersection.dart';
import 'package:affine_transformations/line_algorithms/point_relative_to_line.dart';
import 'package:affine_transformations/line_algorithms/is_point_inside_polygon.dart';
import 'package:affine_transformations/primitives.dart';
import 'package:bloc/bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(CommonState(primitives: [])) {
    on<StartPrimitiveAdding>(_onStartPrimitiveAdding);
    on<AddPointEvent>(_onAddPointEvent);
    on<EndPrimitiveAdding>(_onEndPrimitiveAdding);
    on<ClearCanvasEvent>(_onClearCanvas);
    on<PrimitiveSelectedChanged>(_onPrimitiveSelectedChanged);
    on<RemovePrimitive>(_onPrimitiveRemoving);
    on<LinesIntersectionEvent>(_linesIntersection);
    on<PointRelativeToLineEvent>(_pointRelativeToLine);
    on<IsPointInsidePolygonEvent>(_isPointInsidePolygon);
  }

  void _onStartPrimitiveAdding(StartPrimitiveAdding event, Emitter emit) {
    if (state is PrimitiveAddingState) {
      return;
    } else {
      emit(PrimitiveAddingState(primitives: state.primitives, newPoints: []));
    }
  }

  void _onAddPointEvent(AddPointEvent event, Emitter emit) {
    if (state is PrimitiveAddingState) {
      final primitiveAddingState = state as PrimitiveAddingState;
      emit(primitiveAddingState.copyWith(
          newPoints: primitiveAddingState.newPoints..add(event.point)));
    }
  }

  void _onEndPrimitiveAdding(EndPrimitiveAdding event, Emitter emit) {
    if (state is PrimitiveAddingState) {
      final newPrimitivePoints = (state as PrimitiveAddingState).newPoints;
      if (newPrimitivePoints.isEmpty) {
      } else if (newPrimitivePoints.length == 1) {
        state.primitives.add(Point(newPrimitivePoints.first));
      } else if (newPrimitivePoints.length == 2) {
        state.primitives
            .add(Line(newPrimitivePoints.first, newPrimitivePoints.last));
      } else {
        state.primitives.add(Polygon(newPrimitivePoints));
      }
      emit(CommonState(
        primitives: state.primitives,
      ));
    } else {
      return;
    }
  }

  void _onClearCanvas(ClearCanvasEvent event, Emitter emit) {
    if (state is PrimitiveAddingState) {
      emit(PrimitiveAddingState(primitives: [], newPoints: []));
    } else {
      emit(state.copyWith(primitives: []));
    }
  }

  void _onPrimitiveSelectedChanged(
      PrimitiveSelectedChanged event, Emitter emit) {
    state.primitives[event.index].isSelected =
        !state.primitives[event.index].isSelected;
    emit(state.copyWith());
  }

  void _onPrimitiveRemoving(RemovePrimitive event, Emitter emit) {
    emit(state.copyWith(primitives: state.primitives..removeAt(event.index)));
  }

  void _linesIntersection(LinesIntersectionEvent event, Emitter emit) {
    final selectedPrimitives = <Line>[];
    for (var primitive in state.primitives) {
      if (primitive.isSelected) {
        if (primitive is Line) {
          selectedPrimitives.add(primitive);
        } else {
          emit(state.copyWith(
              message: "Выбранные примитивы должны быть отрезками"));
          return;
        }
      }
    }
    if (selectedPrimitives.length != 2) {
      emit(state.copyWith(message: "Должны быть выбраны ровно 2 отрезка"));
      return;
    }
    final intersectionPoint =
        linesIntersection(selectedPrimitives[0], selectedPrimitives[1]);
    if (intersectionPoint == null) {
      emit(state.copyWith(message: "Отрезки не пересекаются"));
      return;
    }
    emit(state.copyWith(
        primitives: state.primitives..add(Point(intersectionPoint)),
        message: "Точка пересечения найдена, добавлена как примитив"));
  }

  void _pointRelativeToLine(PointRelativeToLineEvent event, Emitter emit) {
    Point? selectedPoint;
    Line? selectedLine;
    bool isLineSelected = false, isPointSelected = false;
    const errorMessage = "Должна быть выбрана 1 точка и 1 отрезок";
    for (var primitive in state.primitives) {
      if (primitive.isSelected) {
        if (primitive is! Line && primitive is! Point) {
          emit(state.copyWith(message: errorMessage));
          return;
        }
        if (primitive is Line) {
          if (isLineSelected) {
            emit(state.copyWith(message: errorMessage));
            return;
          }
          isLineSelected = true;
          selectedLine = primitive;
        }
        if (primitive is Point) {
          if (isPointSelected) {
            emit(state.copyWith(message: errorMessage));
            return;
          }
          isPointSelected = true;
          selectedPoint = primitive;
        }
      }
    }
    if (!isLineSelected || !isPointSelected) {
      emit(state.copyWith(message: errorMessage));
      return;
    }
    final res = pointRelativeToLine(selectedPoint!, selectedLine!);

    final message = '''Точка ${switch (res) {
      RelativePointPosition.left => 'находится слева от отрезка',
      RelativePointPosition.right => 'находится справа от отрезка',
      RelativePointPosition.collinear => 'коллинеарна отрезку',
    }}''';
    emit(state.copyWith(message: message));
  }

  void _isPointInsidePolygon(IsPointInsidePolygonEvent event, Emitter emit) {
    Point? selectedPoint;
    Polygon? selectedPolygon;
    bool isPolygonSelected = false, isPointSelected = false;
    const errorMessage = "Должна быть выбрана 1 точка и 1 многоугольник";
    for (var primitive in state.primitives) {
      if (primitive.isSelected) {
        if (primitive is! Polygon && primitive is! Point) {
          emit(state.copyWith(message: errorMessage));
          return;
        }
        if (primitive is Polygon) {
          if (isPolygonSelected) {
            emit(state.copyWith(message: errorMessage));
            return;
          }
          isPolygonSelected = true;
          selectedPolygon = primitive;
        }
        if (primitive is Point) {
          if (isPointSelected) {
            emit(state.copyWith(message: errorMessage));
            return;
          }
          isPointSelected = true;
          selectedPoint = primitive;
        }
      }
    }
    if (!isPolygonSelected || !isPointSelected) {
      emit(state.copyWith(message: errorMessage));
      return;
    }
    final res = isPointInsidePolygon(selectedPoint!, selectedPolygon!);

    final message = '''Точка ${res ? 'внутри' : 'снаружи'} многоугольника''';
    emit(state.copyWith(message: message));
  }
}
