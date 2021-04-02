import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ViewExpert.dart';
import 'package:flutter/material.dart';
import 'Database.dart';
import 'nav-drawer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class ListPage extends StatefulWidget {
  var t;
  String t2;
  ListPage(t, t2) {
    this.t = t;
    this.t2 = t2;
  }
  @override
  _ListPageState createState() => _ListPageState(t,t2);
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    fetchDataBaseList();
    print(imName);
  }

  String t2;
  var type;
  _ListPageState(type, t2) {
    this.type = type;
    this.t2 = t2;
  }
  var imName;
  viewImage(i) async {
    var img = await Databasers().downloadLink(firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('playground')
        .child(expertProfileList[i]['image name']));
    setState(() {
      imName = img;
    });
    return img;
    //print("rosh"+ x);
  }

  List expertProfileList = [];

  fetchDataBaseList() async {
    dynamic resultant = await DataBaseList().getUsersList(type);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        expertProfileList = resultant;
      });
      print(expertProfileList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new NavDrawer(type: t2),
        backgroundColor: Colors.blue[800],
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.blue[900],
          title: Text(type + "'s " + "List"),
        ),
        body: new Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: expertProfileList.length, //depends on firebase count;;
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.blue[900]),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.white24))),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          expertProfileList[index]['first name'] +
                              " " +
                              expertProfileList[index]['last name'],
                          //"John Marlin",

                          ///this should be expert.name where name is the expert's name@roshdiAlMajzoub
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: LinearProgressIndicator(
                                      backgroundColor:
                                          Color.fromRGBO(209, 224, 224, 0.2),
                                      value: expertProfileList[index]
                                          ['reputation'],
                                      //0.5, //this should be expert.reputation where it will be brought from the expert's database@roshdiAlMajzoub
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.green)),
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
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.white, size: 30.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (ViewExpert(
                                        name: expertProfileList[index]
                                                ['first name'] +
                                            " " +
                                            expertProfileList[index]
                                                ['last name'],
                                        field: type,
                                        id: expertProfileList[index]['id'],
                                        cvName: expertProfileList[index]
                                            ['CV name'],
                                        imgPath: expertProfileList[index]
                                            ['image name'],
                                            
                                      ))));
                        },
                      )),
                );
              }),
        ));
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new NavDrawer(),
      backgroundColor: Colors.blue[800],
      appBar: topAppBar,
      body: makeBody,
    );
  }*/
}
/*
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
                    1, //this should be expert.reputation where it will be brought from the expert's database@roshdiAlMajzoub
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
);*/
