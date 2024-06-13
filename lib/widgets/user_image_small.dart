import 'package:flutter/material.dart';

class UserImageSmall extends StatelessWidget {
  final double width;
  final double height;

  const UserImageSmall({
    super.key,
    required this.imageUrl,
    this.height = 65,
    this.width = 65,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        right: 8,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
