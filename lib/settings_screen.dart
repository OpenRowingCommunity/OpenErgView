import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';

import 'utils.dart';

class SettingsPageView extends StatelessWidget {
  const SettingsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")), body: Text("hello world"));
  }
}
