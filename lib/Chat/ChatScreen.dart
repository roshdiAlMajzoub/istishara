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
  String collection2;
  String collection1;
  bool isConversation;
  var priceRange;
  String secId1;
  ChatScreen({
    @required this.id1,
    @required this.image,
    @required this.name,
    @required this.id,
    this.endtime,
    this.isConversation,
    this.collection2,
    this.id2,
    this.priceRange,
    this.collection1,
    this.secId1,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

TextEditingController msgTextField = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
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
        .collection(widget.collection2)
        .doc(widget.id2);
    List repList;
    await updt.get().then((DocumentSnapshot doc) {
      setState(() {
        repList = doc.data()['reputation'];
      });
    });
    if (rating == null) {
      repList.add(1);
    } else {
      repList.add(rating);
    }

    updt.update({'reputation': repList});

    Navigator.pop(context);
  }

  pay() async {
    var updtExpertMoney = await FirebaseFirestore.instance
        .collection(widget.collection2)
        .doc(widget.id2);
    print(1);
    var updtHelpSeekMoney = await FirebaseFirestore.instance
        .collection(widget.collection1)
        .doc(widget.secId1);

    var expMoney;
    var helpSeekMoney;
    await updtExpertMoney.get().then((DocumentSnapshot doc) {
      setState(() {
        expMoney = doc.data()['money'];
      });
    });
    await updtHelpSeekMoney.get().then((DocumentSnapshot doc) {
      setState(() {
        helpSeekMoney = doc.data()['money'];
      });
    });

    helpSeekMoney = helpSeekMoney - widget.priceRange;
    expMoney = expMoney + widget.priceRange;
    print(helpSeekMoney);
    await updtExpertMoney.update({'money': expMoney});
    await updtHelpSeekMoney.update({'money': helpSeekMoney});
    FirebaseFirestore.instance
        .collection("conversations")
        .doc(widget.id)
        .update({'status': "paid"});
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
                        print(rate);
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
                      Navigator.pop(context);
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
                                pay();
                                Navigator.of(context).pop();
                                showRatingPayment(context);
                              }),
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
