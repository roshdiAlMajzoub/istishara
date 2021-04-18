import 'package:flutter/material.dart';

import 'TextFieldContainer.dart';
import 'constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool obscure;
  final Function onpressed;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.obscure,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Password",
        icon: Icon(
          Icons.lock,
          color: kPrimaryColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.visibility),
          color: kPrimaryColor,
          onPressed: onpressed,
        ),
        border: InputBorder.none,
      ),
    );
  }
}
