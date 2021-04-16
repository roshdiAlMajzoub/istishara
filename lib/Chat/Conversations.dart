import 'package:ISTISHARA/MyCalendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ConversationList.dart';

class Conversations extends StatefulWidget {
  @override
  String id;
  Conversations({@required this.id});
  State<Conversations> createState() => ConversationsState();
}

class ConversationsState extends State<Conversations> {
  @override
  void initState() {
    super.initState();
    fetchDataBaseList();
  }

  Future getUsersList(String id) async {
    List expertList = [];
    Query colcollectionReference =
        FirebaseFirestore.instance.collection("conversations");
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          if (element.get('id1') == id) {
            print("inside if");
            expertList.add(element.data());
          }
        });
      });
      return expertList;
    } catch (e) {
      print(e.toString());
    }
  }

  List conversationsList = [];

  fetchDataBaseList() async {
    dynamic resultant =
        await getUsersList(FirebaseAuth.instance.currentUser.uid);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        conversationsList = resultant;
      });
      print(conversationsList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Conversations"),
        ),
        drawer: Drawer(),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: conversationsList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16),
          itemBuilder: (context, index) {
            return ConversationList(
              name: conversationsList[index]['name2'],
              imageUrl: conversationsList[index]['image2'],
              id2: conversationsList[index]['id2'],
              id:widget.id
            );
          },
        ));
  }
}
