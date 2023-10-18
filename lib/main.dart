import 'package:affine_transformations/bloc/main_bloc.dart';
import 'package:affine_transformations/primitives_painter.dart';
import 'package:affine_transformations/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Material(
        child: BlocProvider<MainBloc>(
            create: (context) => MainBloc(), child: const HomePage()),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (event) {
          if (event.buttons == 2) {
            context.read<MainBloc>().add(const EndPrimitiveAdding());
          }
        },
        child: Row(
          children: [
            const ToolBar(),
            Expanded(
              child: BlocConsumer<MainBloc, MainState>(
                listener: (context, state) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      width: 700,
                      content: Text(
                        state.message!,
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }
                },
                builder: (context, state) {
                  return GestureDetector(
                    onPanDown: (details) {
                      if (state is PrimitiveAddingState) {
                        context
                            .read<MainBloc>()
                            .add(AddPointEvent(details.localPosition));
                      }
                    },
                    child: ClipRRect(
                      child: CustomPaint(
                        foregroundPainter: PrimitivesPainter(
                            primitives: state.primitives,
                            newPoints: switch (state) {
                              CommonState() => null,
                              PrimitiveAddingState() => state.newPoints,
                            },
                            style: Paint()
                              ..color = Colors.black
                              ..strokeWidth = 3),
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
