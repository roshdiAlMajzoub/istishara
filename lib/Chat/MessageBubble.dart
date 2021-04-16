import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  MessageBubble({@required this.message,@required this.isMe});
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.end: MainAxisAlignment.start,
      children: [
      Container(
        decoration: BoxDecoration(
          color: isMe? Colors.grey[300] : Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isMe? Radius.circular(12) : Radius.circular(0),
            bottomRight: isMe?  Radius.circular(0) : Radius.circular(12),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Flexible(
          child: Text(message,
              style: TextStyle(
                 color: isMe? Colors.black : Theme.of(context).accentTextTheme.headline1.color,fontSize: 15)),
        ),
      width: screenWidth / 2.5,
      )
    ]);
  }
}
