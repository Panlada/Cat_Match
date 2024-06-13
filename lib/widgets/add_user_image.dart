import 'package:flutter/material.dart';

class AddUserImage extends StatelessWidget {
  final void Function()? onPressed;

  const AddUserImage({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          width: 1,
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
