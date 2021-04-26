import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ExpertType {
  int id;
  String type;

  ExpertType(this.id, this.type);

  static List<ExpertType> getType() {
    return <ExpertType>[
       ExpertType(22, 'Choose your profession'),
      ExpertType(1, 'Developer'),
      ExpertType(2, 'Civil Engineer'),
      ExpertType(3, 'Electrician'),
      ExpertType(4, 'Dietician'),
      ExpertType(5, 'Personal Trainer'),
      ExpertType(6, 'Plumber'),
      ExpertType(7, 'Business Analyst'),
      ExpertType(8, 'Architect'),
      ExpertType(9, 'Handyman'),
      ExpertType(10, 'Carpenter'),
      ExpertType(11, 'Interior Designer'),
      ExpertType(12, 'BlackSmith'),
      ExpertType(13, 'Industrial Engineer'),
      ExpertType(14, 'Data Scientist'),
      ExpertType(15, 'IT Specialist'),
      ExpertType(16, 'Lawyer'),
      ExpertType(17, 'Chemist'),
      ExpertType(18, 'Biologist'),
      ExpertType(19, 'Physicist'),
      ExpertType(20, 'Physician'),
      ExpertType(21, 'Psychologist'),
    ];
  }
}

class Experts extends StatefulWidget {
  Experts() : super();
  @override
  State<Experts> createState() {
    return new ExpertsState();
  }
}

class ExpertsState extends State<Experts> {
  List<ExpertType> _types = ExpertType.getType();
  List<DropdownMenuItem<ExpertType>> _dropdownMenuItems;
  ExpertType _selectedType;
  static String selected;

  static String getExpertType() {
    return selected;
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_types);
    _selectedType = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<ExpertType>> buildDropdownMenuItems(List types) {
    List<DropdownMenuItem<ExpertType>> items = List();
    for (ExpertType type1 in types) {
      items.add(
        DropdownMenuItem(
          value: type1,
          child: Text(type1.type),
        ),
      );
    }

    return items;
  }

  onChangeDropdownItem(ExpertType selectedType) {
    setState(() {
      _selectedType = selectedType;
      selected = _selectedType.type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedType,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
    );
  }
}
