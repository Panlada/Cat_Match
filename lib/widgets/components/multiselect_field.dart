import 'package:flutter/material.dart';

class TagInputFieldComponent extends StatelessWidget {
  final String? hint;
  final List<String>? initialValue;
  final Function(List<String>)? onChanged;
  final Function(bool)? onFocusChanged;
  final EdgeInsets padding;

  const TagInputFieldComponent({
    super.key,
    this.hint = '',
    this.initialValue = const [],
    this.onChanged,
    this.onFocusChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
  });

  @override
  Widget build(BuildContext context) {
    // List<String> values = [];

    return Padding(
      padding: padding,
      child: Focus(
        onFocusChange: onFocusChanged ?? (hasFocus) {},
        child: TagInputWidget(
          hint: hint,
          initialValue: initialValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class TagInputWidget extends StatefulWidget {
  final String? hint;
  final List<String>? initialValue;
  final Function(List<String>)? onChanged;

  const TagInputWidget({
    super.key,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TagInputWidgetState createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  late List<String> _tags = [];
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _tags = widget.initialValue!;
  }

  void _onChangeTags() {
    widget.onChanged!(_tags);
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag);
      _controller.clear();
    });

    _onChangeTags();
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });

    _onChangeTags();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _tags.asMap().entries.map((entry) {
            int index = entry.key;
            String tag = entry.value;
            return Chip(
              label: Text(tag),
              onDeleted: () => _removeTag(index),
            );
          }).toList(),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onSubmitted: (String value) {
                  if (value.isNotEmpty) {
                    _addTag(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 8.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green.withOpacity(0.8), // Background color
              ),
              onPressed: () {
                String tag = _controller.text.trim();
                if (tag.isNotEmpty) {
                  _addTag(tag);
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
