import 'dart:io';
import 'dart:math';

import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ShowDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendTextField extends StatefulWidget {
  final String id;
  const SendTextField({@required this.id});

  @override
  State<SendTextField> createState() => SendTextFieldState();
}

class SendTextFieldState extends State<SendTextField> {
  final msgTextField = TextEditingController();

  Future<AlertDialog> showDialogEmailVerify(
      String title, String content, String email, BuildContext context1) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Center(
                child: Text(
                  "Choose Source",
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.w900),
                ),
              ),
              content: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 7,
                  ),
                  Container(
                      height: 100,
                      child: Column(children: [
                        IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () {
                              pickImage("Gallery");
                              Navigator.of(context).pop();
                            }),
                        Text("Gallery",
                            style: TextStyle(color: Colors.deepPurple))
                      ])),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 100,
                    child: Column(children: [
                      IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            pickImage("Camera");
                          }),
                      Text("Camera", style: TextStyle(color: Colors.deepPurple))
                    ]),
                  ),
                    SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 100,
                    child: Column(children: [
                      IconButton(
                          icon: Icon(Icons.video_collection_sharp),
                          onPressed: () {
                            pickVideo("Gallery");
                          }),
                      Text("Video", style: TextStyle(color: Colors.deepPurple))
                    ]),
                  ),
                  
                  
                ],
              ));
        });
  }

  File pickedImage;
  String url;
  File pickedVideo;
  String urlVideo;
  void pickImage(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
        source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,);
    pickedImage = File(pickedImageFile.path);
    url = await Databasers().uploadFile(pickedImage, context);
    _sendMessage();
  }

  void pickVideo(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getVideo(
        source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,);
    pickedVideo = File(pickedImageFile.path);
    urlVideo = await Databasers().uploadFile(pickedVideo, context);
    _sendMessage();
  }

  void _sendMessage() async {
    if (msgTextField.value.text.length > 0 && url == null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': msgTextField.value.text,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      msgTextField.clear();
    } else if (url != null && urlVideo==null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': url,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        url = null;
        pickedImage = null;
      });
    }else if(url == null && urlVideo!=null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': "",
        'video':urlVideo,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        urlVideo = null;
        pickedVideo = null;
      });
    }
  }

  bool sendButton = false;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: msgTextField,
                onChanged: (value) {
                  if (value.length > 0) {
                    setState(() {
                      sendButton = true;
                    });
                  } else {
                    setState(() {
                      sendButton = false;
                    });
                  }
                },
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.keyboard),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.attach_file), onPressed: () {}),
                        IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              showDialogEmailVerify(
                                  "title", "content", "email", context);
                            })
                      ],
                    )),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              radius: 25,
              child: IconButton(
                icon: sendButton == true || msgTextField.value.text.length > 0
                    ? Icon(Icons.send)
                    : Icon(Icons.mic),
                onPressed: _sendMessage,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
