import 'package:flutter/material.dart';
import 'package:openergview/data_bar.dart';
import 'package:openergview/data_tile.dart';

class ErgStaggeredView extends StatelessWidget {
  final List<Widget> children;

  const ErgStaggeredView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // account for bottom bar height and padding
    final double itemHeight = (size.height - 80 - 4) / 2;
    final double barHeight = (size.height - 80 - 4) / 4;

    final double itemWidth = size.width / 3;
    return Scaffold(
        body: Row(
      children: <Widget>[
        SizedBox(
            width: size.width * 2 / 3,
            height: size.height - 80 - 4,
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    flex: 2, child: DataBar(defaultValue: 2000, unit: "m")),
                Expanded(flex: 1, child: DataBar(defaultValue: 32, unit: "s/m"))
              ]),
              Row(children: <Widget>[
                Expanded(child: DataBar(defaultValue: 2000, unit: "/500m"))
              ]),
              Row(children: <Widget>[
                Expanded(flex: 2, child: DataBar(defaultValue: 2000)),
                Expanded(
                    flex: 1,
                    child: DataBar(
                        icon: Icons.heart_broken_outlined, defaultValue: 32))
              ]),
              Row(children: <Widget>[
                Expanded(child: DataBar(defaultValue: 2000, unit: "ave/500"))
              ]),
            ])),
        SizedBox(
          width: itemWidth,
          child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: (itemWidth / itemHeight),
              padding: const EdgeInsets.all(2),
              children: children),
        )
      ],
    ));
  }
}
