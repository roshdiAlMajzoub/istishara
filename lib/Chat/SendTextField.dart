import 'dart:io';

import 'package:ISTISHARA/Databasers.dart';
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
  File pickedImage;
  bool isPicture;
  void _sendPictureMessage() async {
    if (false) {
      final url = await Databasers().uploadFile(pickedImage, context);
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("images")
          .add({
        'image': url,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
    } else {
      if (msgTextField.value.text.length > 0) {
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
      }
    }
  }

  void pickImage(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
        source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150);
    setState(() {
      pickedImage = File(pickedImageFile.path);
    });
    _sendPictureMessage();
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
                            onPressed: () async {
                              await pickImage("Gallery");
                            }),
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
                onPressed: _sendPictureMessage,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
