import 'package:flutter/material.dart';
import 'package:openergview/data_tile.dart';

class ErgGridView extends StatelessWidget {
  const ErgGridView({super.key});

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
            children: _buildGridTileList(6)));
  }

  // The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
// The List.generate() constructor allows an easy way to create
// a list when objects have a predictable naming pattern.
  List<DataTile> _buildGridTileList(int count) =>
      List.generate(count, (i) => DataTile(title: "test", value: i.toDouble()));
}
