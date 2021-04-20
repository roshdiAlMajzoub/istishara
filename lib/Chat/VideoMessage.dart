import 'package:ISTISHARA/Chat/FullVideo.dart';
import 'package:ISTISHARA/Chat/Full_Screen_Image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  VideoMessageState(String message) {
    this.message = message;
  }
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.message,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          FlatButton(
            child: Container(
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
              child: Stack(children: [
                VideoPlayer(_controller),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(children: [
                      Text(
                        widget.time,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[100]),
                      ),
                      Text("   "),
                    ]))
              ]),
              height: screenHeight / 3,
              width: screenWidth / 1.5,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullVideo(url: _controller)));
            },
          )
        ]);
  }
}
