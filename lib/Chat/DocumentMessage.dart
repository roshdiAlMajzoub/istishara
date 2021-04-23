import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pdftron_flutter/pdftron_flutter.dart';

class DocumentMessage extends StatefulWidget {
  DocumentMessage(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  final String message;
  bool isMe;
  final Key key;
  String time;
  @override
  State<DocumentMessage> createState() =>
      DocumentMessageState(message: message, isMe: isMe, key: key, time: time);
}

class DocumentMessageState extends State<DocumentMessage> {
  final String message;
  bool isMe;
  final Key key;
  File file;
  String url;
  String time;
  bool fetchFileFromOnline = true;
  DocumentMessageState(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  String icon;
  void getType() {
    String type = message.split("?")[0].split(".")[1];
    switch (type) {
      case "pptx":
        icon = "asset/icons/powerpoint.svg";
        break;
      case "ppt":
        icon = "asset/icons/powerpoint.svg";
        break;
      case "doc":
        icon = "asset/icons/word.svg";
        break;
      case "docx":
        icon = "asset/icons/word.svg";
        break;
       case "txt":
        icon = "asset/icons/txt-file.svg";
        break;
      case "pdf":
        icon = "asset/icons/pdf.svg";
        break;
      case "xls":
        icon = "asset/icons/excel.svg";
        break;
       case "xlsx":
        icon = "asset/icons/excel.svg";
        break;
      default:
    }
  }

  @override
  initState() {
    super.initState();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: screenHeight / 11,
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 2),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Stack(children: [
              Align(
                alignment: Alignment(0, 0),
                child: Row(children: [
                   IconButton(icon: SvgPicture.asset(icon), onPressed: null),
                 
                  IconButton(
                      icon: Icon(Icons.download_sharp),
                      onPressed: () async {
                        if (await canLaunch(message)) {
                          await launch(message);
                        } else {
                          throw 'Could not launch docPath';
                        }
                      }),
                  IconButton(
                      icon: Icon(Icons.remove_red_eye_rounded),
                      onPressed: () async {
                        await PdftronFlutter.openDocument(message);
                        await PdftronFlutter.saveDocument();
                        var a = await PdftronFlutter.getDocumentPath();
                      }),
                ]),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(children: [
                    Text(
                      widget.time,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(""),
                  ]))
            ]),
            width: screenWidth / 2.2,
          )
        ]);
  }
}
