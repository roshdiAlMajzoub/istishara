import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Database.dart';
import 'ExpertType.dart';

class Helper {
  int clearInfo(
      TextEditingController _FirstNameController,
      TextEditingController _LastNameController,
      TextEditingController _PhoneController,
      TextEditingController _EmailController,
      TextEditingController _PasswordController,
      TextEditingController _ConfirmPasswordController) {
    _FirstNameController.clear();
    _LastNameController.clear();
    _PhoneController.clear();
    _EmailController.clear();
    _PasswordController.clear();
    _ConfirmPasswordController.clear();
    return 0;
  }

  String expertt() {
    String exp = ExpertsState.getExpertType();
    return exp;
  }

  bool validEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool validPhoneNumber(String number) {
    try {
      int.parse(number);
    } on Exception {
      return false;
    }
    var validPrefixes = ["79", "78", "03", "81", "70", "71"];
    String prefix = number.substring(0, 2);
    if (number.length == 8 && validPrefixes.contains(prefix)) {
      return true;
    }
    return false;
  }
}