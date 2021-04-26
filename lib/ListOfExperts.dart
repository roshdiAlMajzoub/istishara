import 'dart:math';

import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:ISTISHARA/ViewExpert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Database.dart';
import 'nav-drawer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class MainListPage extends StatelessWidget {
  var t;
  var collection;
  @override
  Widget build(BuildContext context) {
    return new ListPage(t, collection);
  }
}

// ignore: must_be_immutable
class ListPage extends StatefulWidget {
  var t;
  var collection;
  ListPage(t, collection) {
    this.t = t;
    this.collection = collection;
  }
  @override
  _ListPageState createState() => _ListPageState(t, collection);
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    fetchDataBaseList();
  }

  String t2;
  var type;
  var collection;
  _ListPageState(type, collection) {
    this.type = type;
    this.collection = collection;
  }
  getNumberOfRecords(type, id) async {
    List nbOfRecord = [];
    Query collectionRef = FirebaseFirestore.instance
        .collection("Appt")
        .where('id2', isEqualTo: id)
        .where('state', isEqualTo: "Accepted");

    await collectionRef.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        nbOfRecord.add(element.data());
      });
    });
    return nbOfRecord.length.toString();
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
    }
  }

  List<Color> lst = [
    Colors.orange[600],
    Colors.blue[500],
    Colors.indigoAccent[700],
    Colors.pink,
    Colors.lime[600],
    Colors.red,
    Colors.amber[900],
    Colors.purple[300],
    Colors.amber[400],
    Colors.pink,
    Colors.purple,
    Colors.grey,
    Colors.indigo,
    Colors.cyan[900],
    Colors.blueAccent,
    Colors.deepOrange
  ];
  final _random = new Random();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new NavDrawer(
          type: "Expert",
          collection: collection,
        ),
        
        appBar: AppBar(
          elevation: 0.1,
          title: Text(type + "'s " + "List"),
        ),
        body: new Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: expertProfileList.length, 
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: lst[_random.nextInt(lst.length)]),
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
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        

                        subtitle: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: LinearProgressIndicator(
                                      backgroundColor:
                                          Color.fromRGBO(209, 224, 224, 0.2),
                                      value: (expertProfileList[index]
                                                          ['reputation']
                                                      .reduce((a, b) => a + b) /
                                                  expertProfileList[index]
                                                          ['reputation']
                                                      .length)
                                              .toDouble() /
                                          5,
                                      
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.green)),
                                )),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                      "Reputable", 
                                      style: TextStyle(color: Colors.white))),
                            )
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.white, size: 30.0),
                        onTap: () async {
                          String nbOfRec = await getNumberOfRecords(
                              type, expertProfileList[index]['id']);
                         
                          String reputation = ((expertProfileList[index]
                                                  ['reputation']
                                              .reduce((a, b) => a + b) /
                                          expertProfileList[index]['reputation']
                                              .length)
                                      .toDouble() /
                                  5)
                              .toString();
                          if (reputation.length > 4) {
                            reputation = reputation.substring(0, 4);
                          }
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
                                        collection: collection,
                                        reputation: reputation,
                                        nbOfRecords: nbOfRec,
                                        price: expertProfileList[index]
                                                ['price range']
                                            .toString(),
                                      ))));
                        },
                      )),
                );
              }),
        ));
  }
}
