import 'package:ISTISHARA/Chat/Conversations.dart';
import 'package:ISTISHARA/Chat/Messages.dart';
import 'package:ISTISHARA/Chat/SendTextField.dart';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ShowDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ChatScreen extends StatefulWidget {
  String id1;
  String id2;
  String image;
  String name;
  String id;
  var endtime;
  var messages;
  String collection;
  bool isConversation;
  bool isEnd = false;
  var priceRange;
  ChatScreen({
    @required String id1,
    @required this.image,
    @required this.name,
    @required this.id,
    this.endtime,
    this.isConversation,
    this.collection,
    this.id2,
    this.priceRange,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState(id1: id1);
}

TextEditingController msgTextField = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({@required String id1});
  bool sendButton = false;
  void initState() {
    super.initState();
    getMessages();
  }

  getMessages() async {
    widget.messages = FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.id)
        .collection("messages")
        .orderBy('CreatedAt', descending: true)
        .snapshots();
  }

  updateRating() async {
    var updt = await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.id2);
    List repList;
    await updt.get().then((DocumentSnapshot doc) {
      setState(() {
        repList = doc.data()['reputation'];
      });
    });
    repList.add(rating);

    var avg = repList.reduce((a, b) => a + b) / repList.length;
    print("average is: ");
    print(avg);
    updt.update({'reputation': repList});

    Navigator.pop(context);
  }

  pay() async {
    String coll =
        await Databasers().docExistsIn(FirebaseAuth.instance.currentUser.uid);
    var updt = await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.id2);
    var updtMyMoney = await FirebaseFirestore.instance
        .collection(coll)
        .doc(FirebaseAuth.instance.currentUser.uid);
    var money;
    var myMoney;
    await updt.get().then((DocumentSnapshot doc) {
      setState(() {
        money = doc.data()['money'];
      });
    });
    await updtMyMoney.get().then((DocumentSnapshot doc) {
      setState(() {
        myMoney = doc.data()['money'];
      });
    });
    myMoney = myMoney - widget.priceRange;
    money = money + widget.priceRange;
    print(money);
    print(myMoney);
    await updt.update({'money': money});
    await updtMyMoney.update({'money': myMoney});
  }

  double rating;
  showRatingPayment(BuildContext context1) {
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          final double screenWidth = MediaQuery.of(context1).size.width;
          final double screenHeight = MediaQuery.of(context1).size.height;
          // set to false if you want to force a rating
          return AlertDialog(content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState1) {
            return SingleChildScrollView(
                child: Container(
              width: screenWidth,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      child: Center(
                    child: Text(
                      "Please rate the expert ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  )),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rate) {
                        setState(() {
                          rating = rate;
                        });
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Text(
                      "Your payment will be proceeded once you leave the conversation",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      updateRating();
                    },
                    child: Text("Submit"),
                  ),
                )
              ]),
            ));
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    int endTimeint;
    if (!widget.isConversation) {
      endTimeint = DateTime.now().millisecondsSinceEpoch +
          1000 *
              ((DateTime.now()
                      .difference(
                          DateTime.parse(widget.endtime.toDate().toString()))
                      .inSeconds)
                  .abs());
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isConversation)
                    if (!widget.isEnd)
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Center(
                            child: CountdownTimer(
                                textStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
                                endTime: endTimeint,
                                onEnd: () {
                                  setState(() {
                                    widget.isEnd = true;
                                  });
                                  pay();
                                }),
                          )),
                  if (widget.isEnd)
                    Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              "Leave",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            onPressed: () {
                              showRatingPayment(context);
                              //Navigator.of(context).pop();
                            },
                          ),
                        )),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            child: Messages(
                id1: widget.id1, id: widget.id, messages: widget.messages),
          ),
          if (!widget.isConversation) SendTextField(id: widget.id)
        ])));
  }
}
