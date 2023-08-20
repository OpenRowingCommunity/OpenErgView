import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:openergview/constants.dart';

import 'devices_list/devices_bloc_provider.dart';
import 'devices_list/devices_list_view.dart';
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

                //TODO: if theres a connected erg, show a disconnect button instead
                SettingsTile.navigation(
                  title: Text("Connect to a PM5"),
                  onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DevicesBlocProvider(child: DevicesListScreen()),
                      )),
                ),
              ],
            ),
          ],
        ));
  }
}
