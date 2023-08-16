import 'package:flutter/material.dart';
import 'package:openergview/data_tile.dart';

class ErgGridView extends StatelessWidget {
  final List<DataTile> children;

  const ErgGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var size = MediaQuery.of(context).size;
    // account for bottom bar height and padding
    final double itemHeight = (size.height - 80 - 4) / 2;
    final double itemWidth = size.width / 3;
    return Scaffold(
        body: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            padding: const EdgeInsets.all(4),
            children: children));
  }
}
