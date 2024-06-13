import 'package:flutter/material.dart';

class CustomTextTitle extends StatelessWidget {
  final String text;
  final bool textCenter;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;

  const CustomTextTitle({
    super.key,
    required this.text,
    this.textCenter = false,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment:
            textCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            text,
            textAlign: textCenter ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
