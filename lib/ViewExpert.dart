import 'package:ISTISHARA/Calendar.dart';
import 'package:ISTISHARA/Database.dart';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ViewCalendar.dart';
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
  ViewExpert(
      {@required this.name,
      @required this.field,
      this.id,
      this.cvName,
      this.imgPath});

  @override
  Widget build(BuildContext context) {
    return _ViewExpert(
      name: name,
      field: field,
      id: id,
      cvName: cvName,
      imgPath: imgPath,
    );
  }
}

class _ViewExpert extends StatefulWidget {

  final String name;
  final String field;
  final String id;
  final String cvName;
  final String imgPath;
  _ViewExpert(
      {@required this.name,
      @required this.field,
      this.id,
      this.cvName,
      this.imgPath,});
  @override
  State<_ViewExpert> createState() => _ViewExpertState(
      name: name, field: field, id: id, cvName: cvName, imgPath: imgPath);
}

class _ViewExpertState extends State<_ViewExpert> {
  final String name;
  final String field;
  final String rep;
  var cvLink;
  String id;
  String cvName;
  String imgPath;
  var imgName;
  var x;
  _ViewExpertState(
      {@required this.name,
      @required this.field,
      this.id,
      this.cvName,
      this.imgPath,
      this.rep});

  viewImage() async {
    var img = await Databasers().downloadLink(firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('playground')
        .child(imgPath));

    x = img;

    return img;
    //print("rosh"+ x);
  }

  

  /*Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;
    await Databasers()
        .downloadLink(firebase_storage.FirebaseStorage.instance
            .ref()
            .child('playground')
            .child(imageName))
        .then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }*/

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
    // TODO: implement initState
    super.initState();
    downloadCV();
    viewImage();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: FutureBuilder(
                      future: viewImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(x))));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 15.5,
                            ),
                          );
                        }
                        return Container();
                      },
                    )

                    /*Container(
                        child: Image.network(x),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('asset/images/head.jpg'))))*/
                    ),
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
                        buildText(" Reputation:", "2.5"),
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
                        buildText("Records:", "10")
                      ]),
                    )),
                    Container(height: screenHeight/10,),
                Container(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
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
                    child: RaisedButton(
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewCalendar(id: id,name:name, field: field, color: Colors.grey)));
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
