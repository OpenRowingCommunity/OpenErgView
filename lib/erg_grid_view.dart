import 'package:flutter/material.dart';
import 'package:openergview/data_tile.dart';

class ErgGridView extends StatelessWidget {
  final List<DataTile> children;

  const ErgGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // account for bottom bar height and padding
    final double itemHeight = (size.height - 80 - 4) / 2;
    final double itemWidth = size.width / 3;
    return Scaffold(
        body: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            padding: const EdgeInsets.all(2),
            children: children));
  }
}
