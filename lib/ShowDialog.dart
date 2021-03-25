import "package:flutter/material.dart";

class Show {
 static  Future<AlertDialog> showDialogGiveUp(BuildContext context, State widget,Function clearInfo) {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Give up?!",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              content: Text(
                  "Are you sure you want to give up on setting up your account?\n\nInformation entered will be disregarded."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      widget.setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        clearInfo();
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"))
              ]);
        });
  }

static void showDialogEmailVerify(String title, String content,String email, BuildContext context1) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    showDialog(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            title: Center(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w900),
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState1) {
              return SingleChildScrollView(
                  child: Container(
                alignment: Alignment.center,
                width: screenWidth / 1.8,
                height: screenHeight / 7,
                child: Column(children: [
                  Container(
                      //width: double.infinity,
                      child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  )),
                  Container(
                      child: Text(
                    email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  )),
                  Container(
                    child: Text(
                      'Please verify!',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ]),
              ));
            }),
          );
        });
  }
  static Widget showAlert(String error,State widget) {
    if (error != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                error,
                maxLines: 3,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      widget.setState(() {
                        error = null;
                      });
                    }))
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
   /*void _showDialog(String title, String content, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              )),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState1) {
                return SingleChildScrollView(
                    child: Container(
                  height: screenHeight / 3,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          content,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w900),
                        )),
                    Container(
                        width: double.infinity,
                        child: Row(children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Radio<int>(
                                activeColor: Colors.deepPurple,
                                value: 0,
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState1(() {
                                    radioValue = value;
                                  });
                                },
                              )),
                          Text(_email)
                        ])),
                    Container(
                        width: double.infinity,
                        child: Row(children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Radio<int>(
                                activeColor: Colors.deepPurple,
                                value: 1,
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState1(() {
                                    radioValue = value;
                                  });
                                },
                              )),
                          Text(_phoneNumber)
                        ])),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight / 50, bottom: screenHeight / 50),
                      child: Text(
                        "Please insert the code sent to you here:",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                        height: screenHeight / 15,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            hintText: "Verification Code",
                          ),
                          textAlignVertical: TextAlignVertical(y: 1),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )),
                  ]),
                ));
              }),
              actions: <Widget>[
                TextButton( onPressed:(){Navigator.push( context, MaterialPageRoute(builder: (_) => DashboardScreen()));} , child: Text("Verify"))
              ]);
        });
  }*/
}
