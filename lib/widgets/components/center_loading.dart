import 'package:flutter/material.dart';

class CenterLoadingComponent extends StatelessWidget {
  const CenterLoadingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
