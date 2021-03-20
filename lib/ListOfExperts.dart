import 'package:flutter/material.dart';
import 'package:istishara_test/nav-drawer.dart';

class MainListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new ListPage();
  }
}



class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new NavDrawer(),
      backgroundColor: Colors.blue[800],
      appBar: topAppBar,
      body: makeBody,
    );
  }
}

final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Colors.blue[900],
  title: Text("List of Experts"),
);

final makeBody = Container(
  child: ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10, //depends on firebase count;;
    itemBuilder: (BuildContext context, int index) {
      return makeCard;
    },
  ),
);

final makeCard = Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: BoxDecoration(color: Colors.blue[900]),
    child: makeListTile,
  ),
);

final makeListTile = ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  leading: Container(
    padding: EdgeInsets.only(right: 12.0),
    decoration: new BoxDecoration(
        border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white24))),
    child: Icon(Icons.person, color: Colors.white),
  ),
  title: Text(
    "John Marlin",

    ///this should be expert.name where name is the expert's name@roshdiAlMajzoub
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

  subtitle: Row(
    children: <Widget>[
      Expanded(
          flex: 1,
          child: Container(
            child: LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                value:
                    0.5, //this should be expert.reputation where it will be brought from the expert's database@roshdiAlMajzoub
                valueColor: AlwaysStoppedAnimation(Colors.green)),
          )),
      Expanded(
        flex: 4,
        child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
                "Reputable", //this should be expert.text where it will be brought from the expert's database@roshdiAlMajzoub
                style: TextStyle(color: Colors.white))),
      )
    ],
  ),
  trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
  onTap: () {},
);