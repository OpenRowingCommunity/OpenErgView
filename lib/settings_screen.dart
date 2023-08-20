import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';

import 'utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")), body: Text("hello world"));
  }
}
