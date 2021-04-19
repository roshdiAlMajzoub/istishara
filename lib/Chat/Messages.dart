import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MessageBubble.dart';
import 'ImageCard.dart';

class Messages extends StatelessWidget {
  String id1;
  String id;
  var messages;
  getTime(String time) {
    print(time.substring(12, 16));
    return time.substring(11, 16);
  }

  Messages({@required this.id1, @required this.id,@required this.messages});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: messages,
        builder: (ctxt, chatSnapShot) {
          {
            if (chatSnapShot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                backgroundColor: Colors.transparent, strokeWidth: 0.0,
              );
            }
            return ListView.builder(
                reverse: true,
                itemCount: chatSnapShot.data.docs.length,
                itemBuilder: (ctxt, index) {
                  print(chatSnapShot.data.docs[index]['userID']);
                  print(id1);
                   var  message = chatSnapShot.data.docs[index]['text'];
                    if(message== "")
                    {
                      return ImageBubble(
                      message: chatSnapShot.data.docs[index]['image'],
                      isMe: chatSnapShot.data.docs[index]['userID'] ==
                          FirebaseAuth.instance.currentUser.uid,
                      key: ValueKey(chatSnapShot.data.docs[index].id),
                      time: getTime(chatSnapShot.data.docs[index]['CreatedAt']
                          .toDate()
                          .toString()));
                    }
                  return MessageBubble(
                      message: message,
                      isMe: chatSnapShot.data.docs[index]['userID'] ==
                          FirebaseAuth.instance.currentUser.uid,
                      key: ValueKey(chatSnapShot.data.docs[index].id),
                      time: getTime(chatSnapShot.data.docs[index]['CreatedAt']
                          .toDate()
                          .toString()));
                });
          }
        });
  }
}
