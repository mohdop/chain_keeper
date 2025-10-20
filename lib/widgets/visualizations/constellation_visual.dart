import 'package:flutter/material.dart';

class ConstellationVisual extends StatelessWidget {
  final int streak;
  final double size;

  const ConstellationVisual({
    Key? key,
    required this.streak,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: Text(
          '✨',
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}