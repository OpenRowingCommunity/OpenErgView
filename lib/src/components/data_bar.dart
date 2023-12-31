import 'package:flutter/material.dart';

class DataBar extends StatefulWidget {
  final IconData? icon;
  final String defaultValue;
  final String? unit;
  final int decimals;
  final double fontSize;
  final Stream<String>? stream;

  DataBar(
      {Key? key,
      this.unit = " ",
      this.fontSize = 36,
      this.decimals = 0,
      this.defaultValue = "0",
      this.icon,
      this.stream});

  @override
  _DataBarState createState() => _DataBarState();
}

class _DataBarState extends State<DataBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.shade100,
            border: Border.all(style: BorderStyle.solid, color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.icon != null)
              Icon(
                widget.icon!,
                color: Colors.red,
                size: 24.0,
                semanticLabel: 'Heart Rate',
              )
            else
              SizedBox(width: 50),
            StreamBuilder<String>(
                stream: widget.stream,
                initialData: widget.defaultValue,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    String data = snapshot.data ?? widget.defaultValue;
                    return Text(data,
                        style: TextStyle(
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black));
                  }
                }),
            Text(
              widget.unit ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ));
  }
}
