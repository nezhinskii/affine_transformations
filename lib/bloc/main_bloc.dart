import 'dart:ui';

import 'package:affine_transformations/primitives.dart';
import 'package:bloc/bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(CommonState(primitives: [], selectedPrimitivesIndexes: {})) {
    on<StartPrimitiveAdding>(_onStartPrimitiveAdding);
    on<AddPointEvent>(_onAddPointEvent);
    on<EndPrimitiveAdding>(_onEndPrimitiveAdding);
    on<ClearCanvasEvent>(_onClearCanvas);
    on<SelectPrimitive>(_onSelectPrimitive);
    on<UnselectPrimitive>(_onUnselectPrimitive);
  }

  void _onStartPrimitiveAdding(StartPrimitiveAdding event, Emitter emit) {
    if (state is PrimitiveAddingState){
      return;
    } else {
      emit(PrimitiveAddingState(
        primitives: state.primitives,
        selectedPrimitivesIndexes: state.selectedPrimitivesIndexes,
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
        selectedPrimitivesIndexes: state.selectedPrimitivesIndexes
      ));
    } else {
      return;
    }
  }

  void _onClearCanvas(ClearCanvasEvent event, Emitter emit){
    if (state is PrimitiveAddingState){
      emit(PrimitiveAddingState(
        primitives: [],
        selectedPrimitivesIndexes: {},
        newPoints: [])
      );
    } else {
      emit(state.copyWith(selectedPrimitivesIndexes: {}, primitives: []));
    }
  }

  void _onSelectPrimitive(SelectPrimitive event, Emitter emit){
    emit(state.copyWith(
      selectedPrimitivesIndexes: state.selectedPrimitivesIndexes..add(event.index)
    ));
  }

  void _onUnselectPrimitive(UnselectPrimitive event, Emitter emit){
    emit(state.copyWith(
      selectedPrimitivesIndexes: state.selectedPrimitivesIndexes..remove(event.index)
    ));
  }
}
