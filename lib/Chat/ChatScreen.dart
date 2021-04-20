import 'package:ISTISHARA/Chat/Conversations.dart';
import 'package:ISTISHARA/Chat/Messages.dart';
import 'package:ISTISHARA/Chat/SendTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class ChatScreen extends StatefulWidget {
  String id1;
  String image;
  String name;
  String id;
  var endtime;
  var messages;
  bool isConversation;
  bool isEnd = false;
  ChatScreen(
      {@required String id1,
      @required this.image,
      @required this.name,
      @required this.id,
      this.endtime,
      this.isConversation});
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
                                  fontWeight: FontWeight.w900,),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
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
