import 'dart:ui';

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
  }

  void _onStartPrimitiveAdding(StartPrimitiveAdding event, Emitter emit) {
    if (state is PrimitiveAddingState){
      return;
    } else {
      emit(PrimitiveAddingState(
        primitives: state.primitives,
        newPoints: []
      ));
    }
  }

  void _onAddPointEvent(AddPointEvent event, Emitter emit){
    if (state is PrimitiveAddingState){
      final primitiveAddingState = state as PrimitiveAddingState;
      emit(primitiveAddingState.copyWith(
        newPoints: primitiveAddingState.newPoints..add(event.point)
      ));
    }
  }

  void _onEndPrimitiveAdding(EndPrimitiveAdding event, Emitter emit){
    if (state is PrimitiveAddingState) {
      final newPrimitivePoints = (state as PrimitiveAddingState).newPoints;
      if (newPrimitivePoints.isEmpty){
      } else if (newPrimitivePoints.length == 1){
        state.primitives.add(Point(newPrimitivePoints.first));
      } else if (newPrimitivePoints.length == 2){
        state.primitives.add(Line(newPrimitivePoints.first, newPrimitivePoints.last));
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

  void _onClearCanvas(ClearCanvasEvent event, Emitter emit){
    if (state is PrimitiveAddingState){
      emit(PrimitiveAddingState(
        primitives: [],
        newPoints: [])
      );
    } else {
      emit(state.copyWith(primitives: []));
    }
  }

  void _onPrimitiveSelectedChanged(PrimitiveSelectedChanged event, Emitter emit){
    state.primitives[event.index].isSelected = !state.primitives[event.index].isSelected;
    emit(state.copyWith());
  }

  void _onPrimitiveRemoving(RemovePrimitive event, Emitter emit){
    emit(state.copyWith(
      primitives: state.primitives..removeAt(event.index)
    ));
  }
}
