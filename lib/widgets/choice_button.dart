import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double size;
  final bool hasGradient;
  final Color? color;
  final IconData icon;
  final Function()? onTap;

  const ChoiceButton.small({
    super.key,
    this.width = 60,
    this.height = 60,
    this.size = 25,
    this.hasGradient = false,
    required this.color,
    required this.icon,
    this.onTap,
  });

  const ChoiceButton.large({
    super.key,
    this.width = 80,
    this.height = 80,
    this.size = 30,
    this.hasGradient = true,
    this.color = Colors.white,
    this.icon = Icons.favorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasGradient
              ? LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 4,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
