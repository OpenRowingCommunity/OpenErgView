import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';

class DataTile extends StatefulWidget {
  final String title;
  final double defaultValue;
  final String? unit;
  final Stream<double>? stream;

  DataTile(
      {Key? key,
      this.unit,
      this.title = "",
      this.defaultValue = 0.0,
      this.stream})
      : super(key: key);

  @override
  _DataTileState createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: getDarkGradient(context),
            border: Border.all(style: BorderStyle.solid, color: Colors.white)),
        child: Column(
          children: [
            Text(widget.title),
            StreamBuilder<double>(
                stream: widget.stream,
                initialData: widget.defaultValue,
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    double data = snapshot.data ?? widget.defaultValue;
                    return Text(data.toStringAsPrecision(4));
                  }
                }),
            if (widget.unit != null) Text(widget.unit!),
          ],
        ));
  }
}
