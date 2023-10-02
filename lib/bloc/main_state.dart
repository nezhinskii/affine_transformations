part of 'main_bloc.dart';

sealed class MainState{
  final List<Primitive> primitives;
  final Set<int> selectedPrimitivesIndexes;
  const MainState({
    required this.primitives,
    required this.selectedPrimitivesIndexes
  });

  MainState copyWith({
    List<Primitive>? primitives,
    Set<int>? selectedPrimitivesIndexes
  });
}

class CommonState extends MainState{
  CommonState({
    required super.primitives,
    required super.selectedPrimitivesIndexes
  });

  @override
  CommonState copyWith({
    List<Primitive>? primitives,
    Set<int>? selectedPrimitivesIndexes
  }) => CommonState(
      primitives: primitives ?? this.primitives,
      selectedPrimitivesIndexes: selectedPrimitivesIndexes ?? this.selectedPrimitivesIndexes
  );
}

class PrimitiveAddingState extends MainState{
  final List<Offset> newPoints;
  PrimitiveAddingState({
    required super.primitives,
    required super.selectedPrimitivesIndexes,
    required this.newPoints
  });

  @override
  PrimitiveAddingState copyWith({
    List<Primitive>? primitives,
    Set<int>? selectedPrimitivesIndexes,
    List<Offset>? newPoints
  }) => PrimitiveAddingState(
      primitives: primitives ?? this.primitives,
      newPoints: newPoints ?? this.newPoints,
      selectedPrimitivesIndexes: selectedPrimitivesIndexes ?? this.selectedPrimitivesIndexes
  );
}
