part of 'main_bloc.dart';

sealed class MainState{
  final List<Primitive> primitives;
  final String? message;
  const MainState({
    required this.primitives,
    this.message
  });

  MainState copyWith({
    List<Primitive>? primitives,
    String? message
  });
}

class CommonState extends MainState{
  CommonState({
    required super.primitives,
    super.message
  });

  @override
  CommonState copyWith({
    List<Primitive>? primitives,
    String? message
  }) => CommonState(
    primitives: primitives ?? this.primitives,
    message: message
  );
}

class PrimitiveAddingState extends MainState{
  final List<Offset> newPoints;
  PrimitiveAddingState({
    required super.primitives,
    super.message,
    required this.newPoints
  });

  @override
  PrimitiveAddingState copyWith({
    List<Primitive>? primitives,
    String? message,
    List<Offset>? newPoints
  }) => PrimitiveAddingState(
      primitives: primitives ?? this.primitives,
      message: message,
      newPoints: newPoints ?? this.newPoints,
  );
}
