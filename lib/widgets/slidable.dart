import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomSlidable extends StatelessWidget {

  const CustomSlidable({
    required this.onPressed, super.key,
    this.backgroundColor = Colors.red,
    this.label = 'Delete',
    this.icon = Icons.delete,
  });
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final void Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      label: label,
      icon: icon,
      borderRadius: BorderRadius.circular(18),
    );
  }
}
