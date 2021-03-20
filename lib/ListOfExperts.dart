import 'package:flutter/material.dart';
import 'package:istishara_test/Database.dart';

class ListName extends StatefulWidget {
  @override
  State<ListName> createState() {
    return new Name();
  }
}

class Name extends State<ListName> {
  String c;

  @override
  void initState() {
    super.initState();
    fetchDataBaseList();
  }

  List expertProfileList = [];

  fetchDataBaseList() async {
    dynamic resultant = await DataBaseList().getUsersList('Data Scientist');

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        expertProfileList = resultant;
      });
    }
  }

//above
  List<String> names = [
    'Expert1',
    'Expert2',
    'Expert3',
    'Expert4',
    'Expert5',
    'Expert6',
    'Exper7',
    'Expert8',
    'Expert9',
    'Expert10',
    'Expert11',
    'Expert12',
    'Expert13',
    'Expert14',
    'Expert15',
    'Expert16',
    'Expert17',
    'Expert18',
    'Expert18',
    'Expert19',
    'Expert20'
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("My List App"),
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: expertProfileList.length,
          reverse: false,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(expertProfileList[index]['first name']),
                subtitle: Text(expertProfileList[index]['email']),
                trailing: Text(expertProfileList[index]['reputation'].toString()),
              ),
            );
          },
          //itemBuilder: (_, int index) =>
          // =EachList(expertProfileList[index]['first name']),

          //itemBuilder: (_, int index) => EachList(this.names[index]),
          
          //itemCount: this.names.length,
        ),
      ),
    );
  }
}

class EachList extends StatelessWidget {
  final String name;
  EachList(this.name);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        padding: EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(name[0]),
            ),
            new Padding(padding: EdgeInsets.only(right: 10.0)),
            new Text(
              name,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
