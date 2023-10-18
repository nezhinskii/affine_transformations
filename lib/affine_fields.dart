import 'package:flutter/material.dart';

class AffineFields extends StatelessWidget {
  const AffineFields({
    super.key,
    required this.onXChanged,
    required this.onYChanged,
    required this.onAngleChanged,
    required this.onKChanged,
    required this.onSubmit,
  });

  final void Function(String) onXChanged;
  final void Function(String) onYChanged;
  final void Function(String) onAngleChanged;
  final void Function(String) onKChanged;

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Text("Перемещение"),
          TextField(
            decoration: const InputDecoration(hintText: "dx"),
            onChanged: onXChanged,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "dy"),
            onChanged: onYChanged,
          ),
          const Text("Вращение"),
          TextField(
            decoration: const InputDecoration(hintText: "угол"),
            onChanged: onAngleChanged,
          ),
          const Text("Масштабирование"),
          TextField(
            decoration: const InputDecoration(hintText: "k"),
            onChanged: onKChanged,
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text(
              "Преобразовать",
            ),
          ),
        ],
      ),
    );
  }
}
