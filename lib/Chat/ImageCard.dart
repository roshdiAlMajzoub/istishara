import 'package:ISTISHARA/Chat/Full_Screen_Image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  final Key key;
  String time;
  ImageBubble(
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
        children: [
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
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child:
                Stack( children: [
                   Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                              ),
                              width: screenWidth/2,
                              height: screenHeight/3.5,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: message,
                            width: screenWidth/1.5,
                            height: screenHeight/3.8,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => FullPhoto(url: message)));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                     margin: EdgeInsets.only(bottom:  4.0  , right: 4.0,top: 4.0,left: 4.0),
                    ),
             Positioned(
        bottom: 0,
        right: 0,
                child: Row(children:[Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: 
                        Colors.grey[100]
                  ),
                ),
                Text("   ")
                ,])
              )
            ]),
          ),
        ]);
  }
}
