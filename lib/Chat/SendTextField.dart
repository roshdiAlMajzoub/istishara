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

  Future<AlertDialog> CameraSource(BuildContext context1) {
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
                            pickImage("Take a Photo");
                            Navigator.of(context).pop();
                          }),
                      Text("Take a Photo",
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
                          icon: Icon(Icons.video_collection_sharp),
                          onPressed: () {
                            pickVideo("Record a Video");
                            Navigator.of(context).pop();
                          }),
                      Text("Record a Video",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold))
                    ]),
                  ),
                ],
              ));
        });
  }

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
                          icon: Icon(Icons.video_collection_sharp),
                          onPressed: () {
                            pickVideo("Gallery");
                            Navigator.of(context).pop();
                          }),
                      Text("Video",
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
                          icon: Icon(Icons.video_collection_sharp),
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
                ],
              ));
        });
  }

  File pickedImage;
  String url;
  File pickedVideo;
  String urlVideo;
  String urlAudio;

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

  void pickImage(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
      source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,
    );
    pickedImage = File(pickedImageFile.path);
    url = await Databasers().uploadFile(pickedImage, context);
    _sendMessage();
  }

  void pickVideo(String source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getVideo(
      source: source == "Gallery" ? ImageSource.gallery : ImageSource.camera,
    );
    pickedVideo = File(pickedImageFile.path);
    urlVideo = await Databasers().uploadFile(pickedVideo, context);
    _sendMessage();
  }

  void _sendMessage() async {
    if (msgTextField.value.text.length > 0 && url == null && urlVideo == null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': msgTextField.value.text,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid,
        'image': "",
        'video': "",
        'audio':"",
      });
      msgTextField.clear();
    } else if (url != null && urlVideo == null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': url,
        'video': "",
        'audio':"",
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        url = null;
        pickedImage = null;
      });
    } else if (url == null && urlVideo != null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': "",
        'video': urlVideo,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        urlVideo = null;
        pickedVideo = null;
      });
    }
    else if (url == null && urlVideo == null && urlAudio!=null) {
      FirebaseFirestore.instance
          .collection("conversations")
          .doc(widget.id)
          .collection("messages")
          .add({
        'text': "",
        'image': "",
        'video': "",
        'audio':urlAudio,
        'CreatedAt': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser.uid
      });
      setState(() {
        urlAudio = null;
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
                              CameraSource(context);
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
