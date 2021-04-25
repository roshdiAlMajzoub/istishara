import 'package:ISTISHARA/MyCalendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../nav-drawer.dart';
import '../Databasers.dart';
import 'ConversationList.dart';

class Conversations extends StatefulWidget {
  @override
  List conversations;
  Conversations({@required this.conversations});
  State<Conversations> createState() => ConversationsState();
}

class ConversationsState extends State<Conversations> {
  String type;
  String collection;
  String pass;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: NavDrawer(type: type, collection: collection, pass: pass),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Conversations"),
        ),
        body: widget.conversations == null
            ? Text("")
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.conversations.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  if (widget.conversations[index]['id1'] ==
                      FirebaseAuth.instance.currentUser.uid) {
                    return ConversationList(
                      name: widget.conversations[index]['name2'],
                      imageUrl: widget.conversations[index]['image2'],
                      id: widget.conversations[index]['id'],
                      collection: widget.conversations[index]['collection'],
                      id2: widget.conversations[index]['id2'],
                      priceRange: widget.conversations[index]['price range'],
                    );
                  } else {
                    return ConversationList(
                      name: widget.conversations[index]['name1'],
                      imageUrl: widget.conversations[index]['image1'],
                      id: widget.conversations[index]['id'],
                      collection: widget.conversations[index]['collection'],
                      id2: widget.conversations[index]['id2'],
                      priceRange: widget.conversations[index]['price range'],
                    );
                  }
                }));
  }
}
