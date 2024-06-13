import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String? hint;
  final String? initialValue;
  final String? errorText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final EdgeInsets padding;
  final TextInputType inputType;
  final dynamic maxLines;
  final bool obscureText;

  const TextFieldComponent({
    super.key,
    this.hint = '',
    this.initialValue = '',
    this.errorText,
    this.controller,
    this.onChanged,
    this.onFocusChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Focus(
        onFocusChange: onFocusChanged ?? (hasFocus) {},
        child: TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: inputType,
          maxLines: maxLines,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 18.0),
          // validator: (value) {
          //   if (value == null) {
          //     return 'Please enter some text';
          //   }
          //   return null;
          // },
          decoration: InputDecoration(
            // labelText: title,
            // labelStyle: const TextStyle(
            //   fontSize: 24,
            //   fontWeight: FontWeight.w500,
            // ),
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
            errorStyle: const TextStyle(
              color: Colors.black54,
            ),
            errorText: errorText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
