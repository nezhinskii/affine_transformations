part of 'main_bloc.dart';

sealed class MainState{
  final List<Primitive> primitives;
  const MainState({
    required this.primitives,
  });

  MainState copyWith({
    List<Primitive>? primitives,
  });
}

class CommonState extends MainState{
  CommonState({
    required super.primitives,
  });

  @override
  CommonState copyWith({
    List<Primitive>? primitives,
  }) => CommonState(
      primitives: primitives ?? this.primitives,
  );
}

class PrimitiveAddingState extends MainState{
  final List<Offset> newPoints;
  PrimitiveAddingState({
    required super.primitives,
    required this.newPoints
  });

  @override
  PrimitiveAddingState copyWith({
    List<Primitive>? primitives,
    List<Offset>? newPoints
  }) => PrimitiveAddingState(
      primitives: primitives ?? this.primitives,
      newPoints: newPoints ?? this.newPoints,
  );
}
