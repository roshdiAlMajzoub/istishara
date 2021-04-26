import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceMessage extends StatefulWidget {
  VoiceMessage(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  final String message;
  bool isMe;
  final Key key;
  String time;
  @override
  State<VoiceMessage> createState() =>
      VoiceMessageState(message: message, isMe: isMe, key: key, time: time);
}

class VoiceMessageState extends State<VoiceMessage> {
  final String message;
  bool isMe;
  final Key key;
  String time;
  bool isPlaying = false;
  File file;
  String url;
  bool fetchVideoFromOnline = true;
  bool isLoading = false;
  VoiceMessageState(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  AudioPlayer audioPlayer = AudioPlayer();
  String currentTime = "0:00";
  String completeTime = "0:00";
  @override
  void initPlatformState() async {
    FileInfo fileInfo = await DefaultCacheManager().getFileFromCache(message);
  

    if (fileInfo == null) {
     

      setState(() {
        fetchVideoFromOnline = true;
      });

      file = await DefaultCacheManager().getSingleFile(widget.message);
    } else {
     
      setState(() {
        fetchVideoFromOnline = false;
        file = fileInfo.file;
      });
    }
  }

  void initState() {
    initPlatformState();
    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0].substring(3);
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0].substring(3);
      });
    });
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
                  CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/whatsup-5827e.appspot.com/o/music.jpg?alt=media&token=aa1c7377-6879-4236-856e-d41b167e4842")),

                  if(isLoading)
                     CircularProgressIndicator(),
                  if ((!isPlaying ||
                      audioPlayer.state == AudioPlayerState.COMPLETED ) && !isLoading)
                    IconButton(
                        tooltip: "press to play audio",
                        icon: Icon(Icons.play_arrow),
                        onPressed: () async {
                          setState(() {
                            isPlaying = true;
                          });
                         
                          if (fetchVideoFromOnline) {
                            setState(() {
                              isLoading = true;
                            });
                            await audioPlayer.play(message, isLocal: false);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                           
                            if (fetchVideoFromOnline) {
                              setState(() {
                                isLoading = true;
                              });
                              await audioPlayer.play(message, isLocal: true);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }),
                  if (isPlaying)
                    IconButton(
                        tooltip: "press to stop audio",
                        icon: Icon(Icons.pause),
                        onPressed: () async {
                          setState(() {
                            isPlaying = false;
                          });
                          await audioPlayer.pause();
                        }),
                  Text(
                    currentTime,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(" | "),
                  Text(
                    completeTime,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
              
                  IconButton(
                      icon: Icon(Icons.file_download),
                        onPressed: () async {
                          if (await canLaunch(message)) {
                            await launch(message);
                          } else {
                            throw 'Could not launch docPath';
                          }
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
                    Text("   "),
                  ]))
            ]),
            width: screenWidth / 1.6,
          )
        ]);
  }
}
