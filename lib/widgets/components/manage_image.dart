import 'package:flutter/material.dart';

class ManageImageComponent extends StatelessWidget {
  final String imageUrl;
  final bool isEditingOn;
  final void Function()? onPressedAdd;
  final void Function()? onPressedRemove;

  const ManageImageComponent({
    super.key,
    required this.onPressedRemove,
    required this.onPressedAdd,
    this.imageUrl = '',
    this.isEditingOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 115,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: (imageUrl.isEmpty)
              ? const AssetImage('assets/images/placeholder-image.png')
                  as ImageProvider
              : NetworkImage(imageUrl),
        ),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1,
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      child: (imageUrl.isEmpty)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      // size: 14,
                    ),
                    onPressed: onPressedAdd,
                  ),
                ),
              ),
            )
          : isEditingOn
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                          // size: 14,
                        ),
                        onPressed: onPressedRemove,
                      ),
                    ),
                  ),
                )
              : null,
    );
  }
}
