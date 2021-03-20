import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ExpertType {
  int id;
  String type;

  ExpertType(this.id, this.type);

  static List<ExpertType> getType() {
    return <ExpertType>[
      ExpertType(1, 'Software Engineer'),
      ExpertType(2, 'Civil Engineer'),
      ExpertType(3, 'Electrician'),
      ExpertType(4, 'Dietician'),
      ExpertType(5, 'Personal Trainer'),
      ExpertType(6, 'Business Analyst'),
      ExpertType(7, 'Architect'),
      ExpertType(8, 'Plumber'),
      ExpertType(9, 'Data Scientist'),
      ExpertType(10, 'Industrial Engineer'),
      ExpertType(11, 'IT Specialist'),
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
    //print(selected);
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
