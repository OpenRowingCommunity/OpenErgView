import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:openergview/constants.dart';

import 'utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Connection'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: Text("Connect to a PM5"),
                ),
              ],
            ),
          ],
        ));
  }
}
