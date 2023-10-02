import 'package:affine_transformations/bloc/main_bloc.dart';
import 'package:affine_transformations/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key? key}) : super(key: key);

  String _calcPrimitiveTitle(List<Primitive> primitives, int index){
    final String title;
    switch(primitives[index]){
      case Point():
        int pointIndex = 1;
        for (int i = 0; i < index; ++i){
          if (primitives[i] is Point){
            pointIndex++;
          }
        }
        title = "Точка $pointIndex";
      case Line():
        int lineIndex = 1;
        for (int i = 0; i < index; ++i){
          if (primitives[i] is Line){
            lineIndex++;
          }
        }
        title = "Отрезок $lineIndex";
      case Polygon():
        int polygonIndex = 1;
        for (int i = 0; i < index; ++i){
          if (primitives[i] is Polygon){
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
      width: 220,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          BlocBuilder<MainBloc, MainState>(
            builder: (context, state) => ElevatedButton(
              onPressed: switch(state) {
                CommonState() => () {
                  context.read<MainBloc>().add(const StartPrimitiveAdding());
                },
                PrimitiveAddingState() => () {
                  context.read<MainBloc>().add(const EndPrimitiveAdding());
                },
              },
              child: Text(
                switch(state){
                  CommonState() => "Добавить примитив",
                  PrimitiveAddingState() => "Завершить добавление примитива",
                },
                textAlign: TextAlign.center,
              )
            ),
          ),
          const SizedBox(height: 20,),
          const Text("Список примитивов"),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2
              )
            ),
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) => switch (state.primitives.isEmpty){
                true => const Text("Пусто", textAlign: TextAlign.center,),
                false => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _PrimitiveTile(
                    title: _calcPrimitiveTitle(state.primitives, index),
                    isSelected: state.selectedPrimitivesIndexes.contains(index),
                    onTap: state.selectedPrimitivesIndexes.contains(index) ? () {
                      context.read<MainBloc>().add(UnselectPrimitive(index));
                    } : () {
                      context.read<MainBloc>().add(SelectPrimitive(index));
                    }
                  ),
                  itemCount: state.primitives.length,
                ),
              },
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<MainBloc>().add(const ClearCanvasEvent());
            },
            child: const Text("Очистить")
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}

class _PrimitiveTile extends StatelessWidget {
  const _PrimitiveTile({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap
  }) : super(key: key);
  final String title;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Checkbox(
              fillColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
              value: isSelected,
              onChanged: null,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}
