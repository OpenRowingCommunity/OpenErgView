import 'package:flutter/material.dart';
import 'src/components/data_tile.dart';

class ErgGridView extends StatelessWidget {
  final List<DataTile> children;

  const ErgGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // account for bottom bar height and padding
    double spaceHeight = size.height - kBottomNavigationBarHeight;

    final double itemHeight = spaceHeight / 2;
    final double itemWidth = size.width / 3;
    return Scaffold(
        body: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            padding: const EdgeInsets.all(2),
            children: children));
  }
}
