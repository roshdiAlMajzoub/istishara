
import 'package:ISTISHARA/Chat/Messages.dart';
import 'package:ISTISHARA/Chat/SendTextField.dart';


import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  String id1;
  String id2;
  String image;
  String name;
  String id;

  ChatScreen(
      {@required String id1,
      @required String id2,
      @required this.image,
      @required this.name,
      @required this.id});
  @override
  _ChatScreenState createState() => _ChatScreenState(id1: id1, id2: id2);
}

TextEditingController msgTextField = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {

  _ChatScreenState({@required String id1, @required String id2});
  bool sendButton = false;

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ),
        ),
        body: Container(
          child:
            Column(children: <Widget>[
           Expanded(child:Messages(id1: widget.id1, id2: widget.id2, id: widget.id),),
          SendTextField(id:widget.id)
        ])
        )
        );
  }
}
