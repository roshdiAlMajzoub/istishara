import 'package:ISTISHARA/Calendar.dart';
import 'package:ISTISHARA/Database.dart';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ViewCalendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class ViewExpert extends StatelessWidget {
  final String name;
  final String field;
  final String id;
  final String cvName;
  final String imgPath;
  String collection;
  String reputation;
  String nbOfRecords;
  ViewExpert(
      {@required this.name,
      @required this.field,
      this.id,
      this.cvName,
      this.imgPath,
      this.collection,
      this.reputation,
      this.nbOfRecords});

  @override
  Widget build(BuildContext context) {
    return _ViewExpert(
      name: name,
      field: field,
      id: id,
      cvName: cvName,
      imgPath: imgPath,
      collection: collection,
      reputation: reputation,
      nbOfRecords: nbOfRecords,
    );
  }
}

class _ViewExpert extends StatefulWidget {
  final String name;
  final String field;
  final String id;
  final String cvName;
  final String imgPath;
  final String reputation;
  String collection;
  String nbOfRecords;
  _ViewExpert({
    @required this.name,
    @required this.field,
    this.id,
    this.cvName,
    this.imgPath,
    this.collection,
    this.reputation,
    this.nbOfRecords,
  });
  @override
  State<_ViewExpert> createState() => _ViewExpertState(
      name: name,
      field: field,
      id: id,
      cvName: cvName,
      imgPath: imgPath,
      collection: collection,
      reputation: reputation,
      nbOfRecords: nbOfRecords);
}

class _ViewExpertState extends State<_ViewExpert> {
  final String name;
  final String field;
  final String rep;
  var cvLink;
  String id;
  String cvName;
  String imgPath;
  var x;
  String collection;
  String reputation;
  String nbOfRecords;
  _ViewExpertState(
      {@required this.name,
      @required this.field,
      this.id,
      this.cvName,
      this.imgPath,
      this.rep,
      this.collection,
      this.reputation,this.nbOfRecords,});

 


  downloadCV() async {
    var a = await Databasers().downloadLink(firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('playground')
        .child(cvName));
    setState(() {
      cvLink = a;
    });
  }

  @override
  void initState() {
    super.initState();
    downloadCV();
  }

  @override
  Widget build(BuildContext context) {
    print(collection);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(title: Text(name)),
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Align(
            alignment: Alignment(-1, -0.85),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ),
          Align(
              alignment: Alignment(0, -1),
              child: Column(children: [
               Container(
                    width: screenWidth / 2.75,
                    height: screenHeight / 3,
                    padding: EdgeInsets.only(bottom: 0),
                    child: CircleAvatar(
                      backgroundImage:NetworkImage(imgPath),)),

                Container(
                    padding: EdgeInsets.only(top: 0, bottom: 15),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 0, bottom: 15),
                    child: Text(
                      field,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    )),
                Card(
                    color: Colors.white,
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
                    child: SizedBox(
                      height: screenHeight / 7,
                      child: Row(children: [
                        buildText(" Reputation:", reputation),
                        VerticalDivider(
                          color: Colors.black,
                          indent: 15,
                          endIndent: 15,
                          thickness: 1,
                        ),
                        buildText("Price Range:", "2-3 LBP"),
                        VerticalDivider(
                          color: Colors.black,
                          indent: 15,
                          endIndent: 15,
                          thickness: 1,
                        ),
                        buildText("Records:", nbOfRecords)
                      ]),
                    )),
                Container(
                  height: screenHeight / 10,
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        _showDialog("title", cvLink, context);
                        //Databasers().downloadFileExample();
                        /*Databasers().downloadFile(firebase_storage.FirebaseStorage.instance
                                                    .ref()
                                                    .child('playground')
                                                    .child('BirdMeertens98Nested.pdf'));*/
                      },
                      child: Text("View CV",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.deepPurple,
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 20),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        print(collection);
                        print(field);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewCalendar(
                                      id: id,
                                      name: name,
                                      field: field,
                                      color: Colors.grey,
                                      collection: collection,
                                    )));
                      },
                      child: Text("Book Consultation",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.deepPurple,
                    )),
              ])),
        ],
      ),
    );
  }
}

void _showDialog(String title, String url, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          title: Center(
              child: Text(
            "Dowload the CV via this link!",
            style: TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.w900),
          )),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
            return SingleChildScrollView(
                child: Container(
              alignment: Alignment.center,
              width: screenWidth / 1.8,
              height: screenHeight / 7,
              child: Column(children: [
                Container(
                    //width: double.infinity,
                    child: new InkWell(
                  child: new Text(
                    'Dowload CV',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  ),
                  onTap: () => launch(url),
                )
                    /* Text(
                  url,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.w900),
                )*/
                    ),
              ]),
            ));
          }),
        );
      });
}

Widget buildText(String content, String value) {
  return RichText(
      text: TextSpan(
          text: " " + content + '\n',
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          children: [
        TextSpan(
            text: "\n      " + value,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300))
      ]));
}
