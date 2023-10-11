import 'package:affine_transformations/affine_fields.dart';
import 'package:affine_transformations/bloc/main_bloc.dart';
import 'package:affine_transformations/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  String x = "";
  String y = "";
  String angle = "";

  String _calcPrimitiveTitle(List<Primitive> primitives, int index) {
    final String title;
    switch (primitives[index]) {
      case Point():
        int pointIndex = 1;
        for (int i = 0; i < index; ++i) {
          if (primitives[i] is Point) {
            pointIndex++;
          }
        }
        title = "Точка $pointIndex";
      case Line():
        int lineIndex = 1;
        for (int i = 0; i < index; ++i) {
          if (primitives[i] is Line) {
            lineIndex++;
          }
        }
        title = "Отрезок $lineIndex";
      case Polygon():
        int polygonIndex = 1;
        for (int i = 0; i < index; ++i) {
          if (primitives[i] is Polygon) {
            polygonIndex++;
          }
        }
        title = "Многоугольник $polygonIndex";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            right: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
          )),
      height: double.infinity,
      width: 270,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) => ElevatedButton(
                onPressed: switch (state) {
                  CommonState() => () {
                      context
                          .read<MainBloc>()
                          .add(const StartPrimitiveAdding());
                    },
                  PrimitiveAddingState() => () {
                      context.read<MainBloc>().add(const EndPrimitiveAdding());
                    },
                },
                child: Text(
                  switch (state) {
                    CommonState() => "Добавить примитив",
                    PrimitiveAddingState() => "Завершить добавление примитива",
                  },
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Список примитивов"),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            width: 240,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2)),
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) => switch (state.primitives.isEmpty) {
                true => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Пусто",
                      textAlign: TextAlign.center,
                    ),
                  ),
                false => ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 0 || index == state.primitives.length + 1) {
                        return const SizedBox(
                          height: 10,
                        );
                      }
                      return _PrimitiveTile(
                        title: _calcPrimitiveTitle(state.primitives, index - 1),
                        isSelected: state.primitives[index - 1].isSelected,
                        onTap: () {
                          context
                              .read<MainBloc>()
                              .add(PrimitiveSelectedChanged(index - 1));
                        },
                        onRemove: () {
                          context
                              .read<MainBloc>()
                              .add(RemovePrimitive(index - 1));
                        },
                      );
                    },
                    itemCount: state.primitives.length + 2,
                  ),
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<MainBloc>().add(LinesIntersectionEvent());
              },
              child: const Text(
                "Точка пересечения ребер",
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<MainBloc>().add(PointRelativeToLineEvent());
              },
              child: const Text(
                "Расположение точки относительно отрезка",
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MainBloc>().add(IsPointInsidePolygonEvent());
            },
            child: const Text(
              "Расположение точки относительно многоугольника",
              textAlign: TextAlign.center,
            ),
          ),
          AffineFields(
            onXChanged: (val) {
              x = val;
            },
            onYChanged: (val) {
              y = val;
            },
            onAngleChanged: (val) {
              angle = val;
            },
            onSubmit: () {
              context.read<MainBloc>().add(AffineTransformationEvent(
                    dx: x == "" ? null : x,
                    dy: y == "" ? null : y,
                    angle: angle == "" ? null : angle,
                  ),);
            },
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                context.read<MainBloc>().add(const ClearCanvasEvent());
              },
              child: const Text("Очистить")),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _PrimitiveTile extends StatelessWidget {
  const _PrimitiveTile(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onTap,
      required this.onRemove})
      : super(key: key);
  final String title;
  final bool isSelected;
  final Function() onTap;
  final Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Checkbox(
              fillColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              value: isSelected,
              onChanged: null,
            ),
            Text(title),
            const Spacer(),
            IconButton(
                onPressed: onRemove, icon: const Icon(Icons.delete_outline))
          ],
        ),
      ),
    );
  }
}
