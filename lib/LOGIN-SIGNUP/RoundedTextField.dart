import 'package:flutter/material.dart';
import 'TextFieldContainer.dart';
import 'constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hinText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hinText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "Your Email",
          border: InputBorder.none,
        ),
        onChanged: onChanged,
    );
  }
}
