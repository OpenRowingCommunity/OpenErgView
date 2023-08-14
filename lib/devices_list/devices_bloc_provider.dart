import 'package:flutter/widgets.dart';

import 'devices_bloc.dart';

class DevicesBlocProvider extends InheritedWidget {
  final DevicesBloc _devicesBloc;

  DevicesBlocProvider({
    Key? key,
    DevicesBloc? devicesBloc,
    required Widget child,
  })  : _devicesBloc = devicesBloc ?? DevicesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DevicesBloc of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DevicesBlocProvider>()!
      ._devicesBloc;
}
