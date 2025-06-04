import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  final bool isCompleted;

  const MyCheckBox(this.isCompleted, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCompleted ? Theme.of(context).colorScheme.primary : Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: isCompleted
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16.0,
            )
          : null,
    );
  }
}
