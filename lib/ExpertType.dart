import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:istishara_test/DashBoard.dart';
import 'package:istishara_test/UserSignUp.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new MaterialApp(
        home: new Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
            height: size.height * 0.2,
            child: Stack(
              children: <Widget>[
                Container(
                    height: size.height * 0.2 - 2.7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB388FF),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36)),
                    ))
              ],
            )),
        Padding(
            padding: EdgeInsets.all(50),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text("Select what best describes your expertise:",
                      style: TextStyle(color: Colors.black38, fontSize: 20)),
                  SizedBox(
                    height: 30.0,
                  ),
                  DropdownButton(
                    value: _selectedType,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    alignment: Alignment(1, 0),
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text("Upload CV",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff5848CF))),
                      style: ElevatedButton.styleFrom(
                          side:
                              BorderSide(width: 3.0, color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          minimumSize: Size(100, 50)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text('Signup'),
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (_) => DashboardScreen()));
                            
                          })
                    ],
                  )
                ])))
      ])),
    ));
  }
}
