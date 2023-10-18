import 'dart:ui';
import 'package:vector_math/vector_math.dart';

import 'package:affine_transformations/line_algorithms/lines_intersection.dart';
import 'package:affine_transformations/line_algorithms/point_relative_to_line.dart';
import 'package:affine_transformations/line_algorithms/is_point_inside_polygon.dart';
import 'package:affine_transformations/matrix/matrix.dart';
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
    on<AffineTransformationEvent>(_onAffineTransformation);
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

  void _onAffineTransformation(AffineTransformationEvent event, Emitter emit) {
    double? dx;
    if (event.dx != null) {
      dx = double.tryParse(event.dx!);
      if (dx == null) {
        emit(state.copyWith(message: "Не число в dx"));
        return;
      }
    }

    double? dy;
    if (event.dy != null) {
      dy = double.tryParse(event.dy!);
      if (dy == null) {
        emit(state.copyWith(message: "Не число в dy"));
        return;
      }
      else {
        dy = -dy;
      }
    }

    double? angle;
    if (event.angle != null) {
      angle = double.tryParse(event.angle!);
      if (angle == null) {
        emit(state.copyWith(message: "Не число в angle"));
        return;
      }
    }

    double? k;
    if (event.k != null) {
      k = double.tryParse(event.k!);
      if (k == null) {
        emit(state.copyWith(message: "Не число в k"));
        return;
      }
    }


    Offset? move =
        dx != null || dy != null ? Offset(dx ?? 0.0, dy ?? 0.0) : null;
    if (angle != null) {
      angle = radians(angle);
    }

    Iterable<Primitive> selected =
        state.primitives.where((primitive) => primitive.isSelected);

    Point? center;
    for (var p in selected) {
      if (p is Point) {
        if (center != null) {
          emit(state.copyWith(message: "Не выбирайте более одной точки"));
          return;
        }
        center = p;
      }
    }

    if (center == null) {
      double xCenter = 0;
      double yCenter = 0;
      int count = 0;

      for (var primitive in selected) {
        count += primitive.vertices.length;

        for (var point in primitive.vertices) {
          xCenter += point.dx;
          yCenter += point.dy;
        }
      }
      xCenter /= count;
      yCenter /= count;

      center = Point(Offset(xCenter, yCenter));
    }

    if (move != null) {
      for (var primitive in selected) {
        final vertices = <Offset>[];
        for (var point in primitive.vertices) {
          vertices.add(
            _movePoint(
              point,
              move.dx,
              move.dy,
            ),
          );
        }
        primitive.vertices = vertices;
      }
    }

    if (angle != null) {
      for (var primitive in selected) {
        final vertices = <Offset>[];
        for (var point in primitive.vertices) {
          vertices.add(
            _rotatePoint(
              point,
              angle,
              center.position.dx,
              center.position.dy,
            ),
          );
        }
        primitive.vertices = vertices;
      }
    }

    if (k != null) {
      for (var primitive in selected) {
        final vertices = <Offset>[];
        for (var point in primitive.vertices) {
          vertices.add(
            _scalePoint(
              point,
              k,
              center.position.dx,
              center.position.dy,
            ),
          );
        }
        primitive.vertices = vertices;
      }
    }

    emit(state.copyWith());
  }
}

Offset _rotatePoint(
    Offset point, double angle, double xCenter, double yCenter) {
  Matrix mPoint = Matrix.point(point.dx, point.dy);
  Matrix transform = Matrix.rotation(angle, xCenter, yCenter);
  Matrix result = mPoint * transform;
  return Offset(result[0][0], result[0][1]);
}

Offset _movePoint(Offset point, double dx, double dy) {
  Matrix mPoint = Matrix.point(point.dx, point.dy);
  Matrix transform = Matrix.translation(dx, dy);
  Matrix result = mPoint * transform;
  return Offset(result[0][0], result[0][1]);
}

Offset _scalePoint(Offset point, double k, double xCenter, double yCenter) {
  Matrix mPoint = Matrix.point(point.dx, point.dy);
  Matrix transform = Matrix.scaling(k, xCenter, yCenter);
  Matrix result = mPoint * transform;
  return Offset(result[0][0], result[0][1]);
}
