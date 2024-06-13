import 'package:flutter/material.dart';

class CheckboxInput extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool?)? onChanged;

  const CheckboxInput({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
