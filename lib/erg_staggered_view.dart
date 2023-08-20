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
    double spaceHeight = size.height - kBottomNavigationBarHeight;
    final double itemHeight = (spaceHeight) / 2 - 12;

    final double itemWidth = size.width / 3;
    return Scaffold(
        body: Row(
      children: <Widget>[
        Container(
            width: itemWidth * 2,
            height: spaceHeight,
            padding: const EdgeInsets.fromLTRB(2, 2, 0, 2),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: DataBar(defaultValue: 2000, unit: "m")),
                        Expanded(
                            flex: 1,
                            child: DataBar(defaultValue: 32, unit: "s/m"))
                      ])),
                  Expanded(
                      flex: 2,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: DataBar(
                              defaultValue: 2000,
                              unit: "/500m",
                              fontSize: 64,
                            ))
                          ])),
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Expanded(flex: 2, child: DataBar(defaultValue: 2000)),
                        Expanded(
                            flex: 1,
                            child:
                                DataBar(icon: Icons.favorite, defaultValue: 32))
                      ])),
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Expanded(
                            child: DataBar(defaultValue: 2000, unit: "ave/500"))
                      ])),
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
