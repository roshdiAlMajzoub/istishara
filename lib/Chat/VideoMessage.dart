import 'dart:io';

import 'package:ISTISHARA/Chat/FullVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoMessage extends StatefulWidget {
  final String message;
  bool isMe;
  bool isPressed = false;
  final Key key;
  String time;
  VideoMessage(
      {@required this.message,
      @required this.isMe,
      @required this.key,
      @required this.time});
  @override
  State<VideoMessage> createState() => VideoMessageState(message);
}

class VideoMessageState extends State<VideoMessage> {
  String message;
  File file;
  bool fetchVideoFromOnline = true;
  VideoMessageState(String message) {
    this.message = message;
  }
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  void initPlatformState() async {
    FileInfo fileInfo =
        await DefaultCacheManager().getFileFromCache(widget.message);

    if (fileInfo == null) {
      print('cache ln: caching now ');

      setState(() {
        fetchVideoFromOnline = true;
      });

      file = await DefaultCacheManager().getSingleFile(widget.message);
    } else {
      print('cache ln: ${fileInfo.validTill}');
      setState(() {
        fetchVideoFromOnline = false;
        file = fileInfo.file;
      });
    }
  }

  getMediaWidget() {
    _controller = fetchVideoFromOnline
        ? VideoPlayerController.network(widget.message)
        : VideoPlayerController.file(file);
    _initializeVideoPlayerFuture = _controller.initialize();
    if (fetchVideoFromOnline) {
      setState(() {
        fetchVideoFromOnline = false;
      });
    }

    return _controller;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isMe
                  ? Colors.grey[300]
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft:
                    widget.isMe ? Radius.circular(12) : Radius.circular(0),
                bottomRight:
                    widget.isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: FlatButton(
              child: Stack(children: [
                VideoPlayer(getMediaWidget()),
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FullVideo(
                    url: getMediaWidget(),
                  );
                }));
              },
            ),
            height: screenHeight / 3,
            width: screenWidth / 1.5,
          )
        ]);
  }
}
