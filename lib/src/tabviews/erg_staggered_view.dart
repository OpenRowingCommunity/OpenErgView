import 'dart:io';

import 'package:c2bluetooth/helpers.dart';
import 'package:flutter/material.dart';
import '../../utils.dart';
import '../components/data_bar.dart';
import '../ergometerstore.dart';

class ErgStaggeredView extends StatelessWidget {
  final List<Widget> children;

  final ErgometerStore? ergstore;

  const ErgStaggeredView({super.key, required this.children, this.ergstore});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // account for bottom bar height and padding
    double spaceHeight = size.height - kBottomNavigationBarHeight;

    final double itemHeight = (spaceHeight) / 2 + (Platform.isLinux ? 0 : -12);
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
                            child: DataBar(
                                defaultValue: "2000",
                                unit: "m",
                                stream: getStringDataStream(
                                    ergstore, "general.distance"))),
                        Expanded(
                            flex: 1,
                            child: DataBar(defaultValue: "32", unit: "s/m"))
                      ])),
                  Expanded(
                      flex: 2,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: DataBar(
                                    defaultValue:
                                        wattsToSplit(123, includeTenths: false),
                                    unit: "/500m",
                                    fontSize: 64,
                                    stream: getSplitDataStream(
                                        ergstore, "stroke.power")))
                          ])),
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: DataBar(
                                defaultValue:
                                    durationFormatter(Duration(seconds: 32)),
                                stream: getDurationDataStream(
                                    ergstore, "general.elapsed_time"))),
                        Expanded(
                            flex: 1,
                            child: DataBar(
                                icon: Icons.favorite, defaultValue: "165"))
                      ])),
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        Expanded(
                            child: DataBar(
                                defaultValue:
                                    wattsToSplit(123, includeTenths: false),
                                unit: "ave/500"))
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
