import 'package:flutter/material.dart';

Gradient getDarkGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColorDark,
    ],
  );
}

Gradient getLightGradient(BuildContext context) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColorLight,
    ],
  );
}
