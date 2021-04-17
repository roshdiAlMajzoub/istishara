import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  String id1;
  String id;
  bool isFirstTime = true;
  getUser() async {
    await FirebaseAuth.instance.currentUser;
  }

  Messages({@required this.id1,  @required this.id});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("conversations")
            .doc(id)
            .collection("messages")
            .orderBy('CreatedAt', descending: true)
            .snapshots(),
        builder: (ctxt, ChatSnapShot) {
          {
            if (ChatSnapShot.connectionState == ConnectionState.waiting &&
                isFirstTime) {
              isFirstTime = false;
              return CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                strokeWidth: 0.0,
              );
            }
            return ListView.builder(
                reverse: true,
                //shrinkWrap: true,
                itemCount: ChatSnapShot.data.docs.length,
                itemBuilder: (ctxt, index) {
                  print(ChatSnapShot.data.docs[index]['userID']);
                  print(id1);
                  return MessageBubble(
                      message: ChatSnapShot.data.docs[index]['text'],
                      isMe: ChatSnapShot.data.docs[index]['userID'] ==
                          FirebaseAuth.instance.currentUser.uid);
                });
          }
        });
  }
}
