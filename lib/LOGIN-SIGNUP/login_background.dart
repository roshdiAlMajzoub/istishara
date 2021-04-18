import 'package:flutter/material.dart';

class Login_background extends StatelessWidget {
  final Widget child;
  const Login_background( {
    Key key, 
    @ required
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "asset/images/main_top.png",
                  width: size.width * 0.35,
                )),
            Positioned(
              child: Image.asset("asset/images/main_bottom.png"),
              bottom: 0,
              left: 0,
              width: size.width * 0.3,
            ),
            child,
          ],
        ));
  }
}
