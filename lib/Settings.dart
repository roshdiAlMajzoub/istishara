import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';

class MainSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Settings();
  }
}

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool temp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(type:"Expert"),
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
                  title: 'Deactivate Account',
                  leading: Icon(Icons.perm_device_information),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Delete Account',
                  leading: Icon(Icons.delete),
                  onPressed: (BuildContext context) {},
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
                  switchValue: true,
                  onToggle: (bool value) {},
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
