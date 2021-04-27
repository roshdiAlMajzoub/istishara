import 'package:ISTISHARA/Helpers/ShowDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainSettings extends StatelessWidget {
  var collection;
  var lst;
  @override
  Widget build(BuildContext context) {
    return Settings(collection, lst);
  }
}

class Settings extends StatefulWidget {
  var collection;
  var lst;
  Settings(collection, lst) {
    this.collection = collection;
    this.lst = lst;
  }
  @override
  SettingsState createState() => SettingsState(collection, lst);
}

class SettingsState extends State<Settings> {
  var collection;
  var lst;
  SettingsState(collection, lst) {
    this.collection = collection;
    this.lst = lst;
  }
  bool availabe = true;
  getAvailability() async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        availabe = documentSnapshot.data()['available'];
      });
    });
  }

  updateAvailability() async {

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'available': !availabe});
  }

  bool temp;
  delteAcc() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: lst[0]['email'], password: lst[0]['passwoard']);
      FirebaseFirestore.instance
          .collection(collection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();
      await FirebaseAuth.instance.currentUser.delete();
      Navigator.of(context).pushReplacementNamed('/Login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future<AlertDialog> showDialogDeleteAccount(BuildContext context1) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Are you sure you want to delete your account?!",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      delteAcc();
                      Navigator.of(context).pushReplacementNamed("/Login");
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ]);
        });
  }

  deactivateAcc() {}

  @override
  void initState() {
    super.initState();
    getAvailability();
  }

  @override
  Widget build(BuildContext context) {
    getAvailability();

    return Scaffold(
        drawer: NavDrawer(
          type: "Expert",
          collection: collection,
        ),
        appBar: AppBar(
            title: Text("Settings"),
            elevation: .1,
            backgroundColor: Colors.purple[800]),
        body: SettingsList(
          sections: [
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'Account Settings',
              tiles: [
                SettingsTile(
                  title: 'Delete Account',
                  leading: Icon(Icons.delete),
                  onPressed: (BuildContext context) {
                    delteAcc();
                  },
                ),
              ],
            ),
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'Availability',
              tiles: [
                SettingsTile.switchTile(
                  title: 'Available',
                  leading: Icon(Icons.event_available_outlined),
                  switchValue: availabe,
                  onToggle: (value) {
                    updateAvailability();
                  },
                  switchActiveColor: Colors.orange[800],
                ),
              ],
            ),
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'App',
              tiles: [
                SettingsTile(
                  title: 'Terms of Service',
                  leading: Icon(Icons.assistant_photo),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Open Source Licenses',
                  leading: Icon(Icons.app_settings_alt_outlined),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
          ],
        ));
  }
}
