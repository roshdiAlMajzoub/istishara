import 'dart:io';
import 'dart:math';

import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ShowDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:record/record.dart';

class SendTextField extends StatefulWidget {
  final String id;
  const SendTextField({@required this.id});

  @override
  State<SendTextField> createState() => SendTextFieldState();
}

class SendTextFieldState extends State<SendTextField> {
  final msgTextField = TextEditingController();

  Future<AlertDialog> GallerySource(BuildContext context1) {
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
                  Container(
                    height: 100,
                    child: Column(children: [
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            pickImage("Gallery");
                            Navigator.of(context).pop();
                          }),
                      Text("Image",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold))
                    ]),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 100,
                    child: Column(children: [
                      IconButton(
                          icon: Icon(Icons.keyboard_voice),
                          onPressed: () {
                            pickAudio("Gallery");
                            Navigator.of(context).pop();
                          }),
                      Text("Audio",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 100,
                    child: Column(children: [
                      IconButton(
                          icon: Icon(Icons.file_copy_sharp),
                          onPressed: () {
                            pickDocument("Gallery");
                            Navigator.of(context).pop();
                          }),
                      Text("Doc",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              ));
        });
  }

  File pickedImage;
  String url;
  String urlAudio;
  String urlDoc;

  void pickAudio(String source) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'flac', 'wav', 'mp4'],
      );
      urlAudio = await Databasers().uploadFile(File(result.paths[0]), context);
      _sendMessage();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void pickDocument(String source) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          "docx",
          "doc",
          "xlsx",
          "xls",
          "pptx",
          "ppt",
          "pdf",
          "txt"
        ],
      );
      urlDoc = await Databasers().uploadFile(File(result.paths[0]), context);
      _sendMessage();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void pickImage(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
      source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,
    );
    pickedImage = File(pickedImageFile.path);
    url = await Databasers().uploadFile(pickedImage, context);
    _sendMessage();
  }

  void _sendMessage() async {
    if (msgTextField.value.text.length > 0 &&
        url == null &&
        urlDoc == null &&
        urlAudio == null) {
      bool flag = false;
      for (int i=0; i < msgTextField.value.text.length; i++) {
        if (msgTextField.value.text[i] != ' ') {
          flag = true;
          break;
        }
      }
      if(flag){
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': msgTextField.value.text,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid,
        'image': "",
        'audio': "",
        'doc': "",
      });
      msgTextField.clear();
        }
    } else if (url != null && urlDoc == null && urlAudio == null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': url,
        'audio': "",
        'doc': "",
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        url = null;
        pickedImage = null;
      });
    } else if (url == null && urlAudio != null && urlDoc == null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': "",
        'audio': urlAudio,
        'doc': "",
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        urlAudio = null;
      });
    } else if (url == null && urlAudio == null && urlDoc != null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': "",
        'audio': "",
        'doc': urlDoc,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        urlDoc = null;
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
                            icon: Icon(Icons.attach_file),
                            onPressed: () {
                              GallerySource(context);
                            }),
                        IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              pickImage("camera");
                            })
                      ],
                    )),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              radius: 25,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
