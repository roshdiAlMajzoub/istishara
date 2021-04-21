import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceMessage extends StatelessWidget {
  final String message;
  bool isMe;
  final Key key;
  String time;
  AudioPlayer audioPlayer = AudioPlayer();
  VoiceMessage(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(children: [
                Row(children: [
                  CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/whatsup-5827e.appspot.com/o/music.jpg?alt=media&token=aa1c7377-6879-4236-856e-d41b167e4842")),
                  IconButton(
                      tooltip: "press to play audio",
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        //b.onAudioPositionChanged;
                        print("play");
                        audioPlayer.play(message, isLocal: true);
                      }),
                  IconButton(
                      tooltip: "press to stop audio",
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        
                        audioPlayer.pause();
                      }),
                  IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () async {
                        if (await canLaunch(message)) {
                          await launch(message);
                        } else {
                          throw 'Could not launch docPath';
                        }
                      }),
                ])
              ]))
        ]);
  }
}
