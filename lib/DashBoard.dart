import 'ListOfExperts.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'dart:io';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: NavDrawer(),
      appBar: AppBar(
      title: Text('Types Of Experts')),
      body: DoubleBackToCloseApp(
                snackBar: SnackBar(
                  content: Text('Tap back again to Exit'),
                ),
                child: WillPopScope(
                    onWillPop: () async {
                      if (Platform.isAndroid) {
                        exit(0);
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                      return false;
                    },
      child: IconTheme.merge(
        data: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Software Engineer',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                        icon: Icons.book,
                        text: 'Mechanical Engineer',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ListName()));
                        }),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Nutritionist',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Family Doctor',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Civil Engineer',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Plumber',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Electrician',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Personal Trainer',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.book,
                      text: 'Architect',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ListName()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    Key key,
    @required this.icon,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.6,
              child: FittedBox(
                child: Icon(icon),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 0.8,
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
