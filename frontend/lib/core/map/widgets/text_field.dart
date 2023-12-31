import 'package:flutter/material.dart';
import 'package:hop_on/Utils/colors.dart';

class InputField extends StatefulWidget {
  const InputField(
      this.fieldKey,
      this.focusNode,
      this.name,
      this.icon,
      this.hintText,
      this.obscureText,
      this.validator,
      this.onSaved,
      this.onFieldSubmitted,
      {super.key,
      this.keyboardType = TextInputType.text});

  final Key fieldKey;
  final FocusNode focusNode;
  final String name;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 2.0),
          child: TextFormField(
              key: widget.fieldKey,
              focusNode: widget.focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              onSaved: widget.onSaved,
              validator: widget.validator,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle:
                    const TextStyle(color: AppColors.FONT_GRAY, fontSize: 12.0),
                contentPadding: const EdgeInsets.fromLTRB(5.0, 2.0, 0.0, 2.0),
              ),
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.black)),
        ),
      ),
    );
  }
}
