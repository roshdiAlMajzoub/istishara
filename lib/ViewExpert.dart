import 'package:flutter/material.dart';

class ViewExpert extends StatelessWidget {
  final String name;
  final String field;
  ViewExpert({@required this.name, @required this.field});

  @override
  Widget build(BuildContext context) {
    return _ViewExpert(
      name: name,
      field: field,
    );
  }
}

class _ViewExpert extends StatefulWidget {
  final String name;
  final String field;
  _ViewExpert({@required this.name, @required this.field});
  @override
  State<_ViewExpert> createState() =>
      _ViewExpertState(name: name, field: field);
}

class _ViewExpertState extends State<_ViewExpert> {
  final String name;
  final String field;
  _ViewExpertState({@required this.name, @required this.field});
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(title: Text(name)),
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Align(alignment: Alignment(-1,-0.85), child: IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),onPressed: Navigator.of(context).pop,),),
          Align(
              alignment: Alignment(0, -1),
              child: Column(children: [
                Container(
                    width: screenWidth / 2.75,
                    height: screenHeight / 3,
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('asset/images/head.jpg'))))),
                Container(
                    padding: EdgeInsets.only(top: 0, bottom: 15),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 0, bottom: 15),
                    child: Text(
                      field,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    )),
              Card(
                    color: Colors.white,
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
                    child: SizedBox(
                      height: screenHeight / 7,
                      child: Row(children: [
                        buildText(" Reputation:","3.4"),
                        VerticalDivider(
                          color: Colors.black,
                          indent: 15,endIndent: 15,thickness: 1,
                        ),
                        buildText("Price Range:","2-3 LBP"),
                        VerticalDivider(
                          color: Colors.black,
                          indent: 15,endIndent: 15,thickness: 1,
                        ),
                        buildText("Records:","10")
                      ]),
                    )),
                    Container(padding: EdgeInsets.only(bottom: 20,top: 20),
                    child:
                    RaisedButton(onPressed: (){}, child: Text("View CV",style:TextStyle(color: Colors.white)),color: Colors.deepPurple,)),
                    Container(padding: EdgeInsets.only(bottom: 20),
                    child:
                    RaisedButton(onPressed: (){}, child:Text("View Available time slots",style:TextStyle(color: Colors.white)),color: Colors.deepPurple,)),
                    Container(padding: EdgeInsets.only(bottom: 20),
                    child:
                    RaisedButton(onPressed: (){}, child: Text("Book Consultation",style:TextStyle(color: Colors.white)),color: Colors.deepPurple,)),
              ])),
        ],
      ),
    );
  }
}

Widget buildText(String content,String value) {
  return RichText(text:TextSpan(
    text: " "+content+'\n',
    style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
    children:[
      TextSpan(
        text: "\n      "+value,
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300)
      )
    ]
  ));
}
