import 'package:flutter/material.dart';

class DataTile extends StatefulWidget {
  final String title;
  final double value;
  final String? unit;

  DataTile({Key? key, this.unit, this.title = "", this.value = 0.0})
      : super(key: key);

  @override
  _DataTileState createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(widget.title),
        Text(widget.value.toStringAsPrecision(4)),
        if (widget.unit != null) Text(widget.unit!),
      ],
    ));
  }
}
