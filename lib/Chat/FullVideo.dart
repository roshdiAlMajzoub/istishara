import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullVideo extends StatelessWidget {
  final VideoPlayerController url;

  FullVideo({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullVideoScreen(url: url),
    );
  }
}

class FullVideoScreen extends StatefulWidget {
  final VideoPlayerController url;

  FullVideoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => FullVideoScreenState(url: url);
}

class FullVideoScreenState extends State<FullVideoScreen> {
  final VideoPlayerController url;
  bool isPressed = true;

  FullVideoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return 
    Center(child:Container(height: screenHeight/2, child: SizedBox(child:
    FlatButton(
        child:
         Container(
            child: Stack(children: [
          VideoPlayer(url),
          if (isPressed)
            Center(
                child: FloatingActionButton(
              backgroundColor: Colors.grey[400],
              onPressed: () {
                setState(() {
                  if (url.value.isPlaying) {
                    url.pause();
                  } else {
                    url.play();
                  }
                });
              },
              // Display the correct icon depending on the state of the player.
              child: Icon(
                url.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ))
        ])),
        onPressed: () {
          setState(() {
            isPressed = !isPressed;
          });
        }))));
  }
}
