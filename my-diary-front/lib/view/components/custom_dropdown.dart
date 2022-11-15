import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {

  const CustomDropdown();

  @override
  State<CustomDropdown> createState() => _CustomDropdown();
}

class _CustomDropdown extends State<CustomDropdown> {
  final _valueList = ['맑음', '흐림', '약간 흐림', '비', '눈', '바람'];
  var _selectedValue = '맑음';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child : DropdownButton(
            value: _selectedValue,
            items: _valueList.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          )
        ),
    );
  }
}