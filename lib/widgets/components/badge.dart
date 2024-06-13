import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  final bool hasStroke;
  final Color bgColor;
  final double bgOpacity;

  const CustomBadge({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.bgColor = Colors.pink,
    this.bgOpacity = 1,
    this.hasStroke = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        border: hasStroke ? Border.all(color: bgColor) : null,
        color: bgColor.withOpacity(bgOpacity),
        borderRadius:
            BorderRadius.circular(20.0), // Adjust radius for desired roundness
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
      ),
    );
  }
}
