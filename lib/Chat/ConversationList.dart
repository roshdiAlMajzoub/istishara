import 'dart:async';

import 'package:ISTISHARA/Chat/ChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Databasers.dart';

class ConversationList extends StatefulWidget {
  String name;
  String imageUrl;
  String id;
  ConversationList(
      {@required this.name, @required this.imageUrl, @required this.id});
  @override
  _ConversationListState createState() => _ConversationListState();
}

NetworkImage networkImage;

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print(FirebaseAuth.instance.currentUser.uid);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatScreen(
                id1: FirebaseAuth.instance.currentUser.uid,
                image: widget.imageUrl,
                name: widget.name,
                id: widget.id);
          }));
        },
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        maxRadius: 30,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.5,
            indent: 90,
            endIndent: 20,
          )
        ]));
  }
}
