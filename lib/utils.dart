import 'package:c2bluetooth/helpers.dart';
import 'package:flutter/material.dart';

import 'src/ergometerstore.dart';

bool isTouchDevice(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.android ||
      platform == TargetPlatform.iOS ||
      platform == TargetPlatform.fuchsia;
}

bool isPointerDevice(BuildContext context) => !isTouchDevice(context);

String durationFormatter(Duration value) {
  int seconds = value.inSeconds - (value.inMinutes * Duration.secondsPerMinute);
  return "${value.inMinutes}:$seconds";
}

Stream<double>? getDoubleDataStream(ErgometerStore? ergstore, String datakey) {
  return ergstore?.erg?.monitorForData({datakey}).map((event) {
    var data = event[datakey] as double;
    return data;
  });
}

Stream<String>? getStringDataStream(ErgometerStore? ergstore, String datakey) {
  return ergstore?.erg?.monitorForData({datakey}).map((event) {
    var data = event[datakey].toString();
    return data;
  });
}

Stream<String>? getSplitDataStream(ErgometerStore? ergstore, String datakey) {
  return ergstore?.erg?.monitorForData({datakey}).map((event) {
    var d = event[datakey];
    print(d.toDouble());
    var data = wattsToSplit(d.toDouble(), includeTenths: false);
    return data;
  });
}

Stream<String>? getDurationDataStream(
    ErgometerStore? ergstore, String datakey) {
  return ergstore?.erg?.monitorForData({datakey}).map((event) {
    var data = durationFormatter(
      event[datakey] as Duration,
    );
    return data;
  });
}
