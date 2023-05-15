import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final Function(String val) onChanged;
  String? selectedGender;

  GenderSelector({super.key, required this.onChanged, required selectedGender});

  @override
  GenderSelectorState createState() => GenderSelectorState();
}

class GenderSelectorState extends State<GenderSelector> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      onChanged: (newValue) {
        setState(() {
          widget.selectedGender = newValue;
        });
        widget.onChanged(newValue ?? 'MALE');
      },
      items: ['MALE', 'FEMALE'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
