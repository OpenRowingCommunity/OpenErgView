import 'dart:async';

// import 'package:fimber/fimber.dart';
import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter/material.dart';

import '../erg_page_view.dart';
// import '../model/ble_device.dart';

import 'devices_bloc.dart';
import 'devices_bloc_provider.dart';
// import 'hex_painter.dart';

typedef DeviceTapListener = void Function();

class DevicesListScreen extends StatefulWidget {
  @override
  State<DevicesListScreen> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DevicesListScreen> {
  DevicesBloc? _devicesBloc;
  StreamSubscription<Ergometer>? _appStateSubscription;
  bool _shouldRunOnResume = true;

  @override
  void didUpdateWidget(DevicesListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fimber.d("didUpdateWidget");
  }

  void _onPause() {
    // Fimber.d("onPause");
    _appStateSubscription?.cancel();
    _devicesBloc?.dispose();
  }

  void _onResume() {
    // Fimber.d("onResume");
    // final devicesBloc = _devicesBloc;
    // if (devicesBloc == null) {
    //   // Fimber.d("onResume:: no devicesBloc present");
    //   return;
    // }
    // devicesBloc.init();
    // _appStateSubscription = devicesBloc.pickedDevice.listen((bleDevice) async {
    //   // Fimber.d("navigate to details");
    //   _onPause();
    //   await Navigator.pushNamed(context, "/details");
    //   setState(() {
    //     _shouldRunOnResume = true;
    //   });
    //   // Fimber.d("back from details");
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fimber.d("DeviceListScreenState didChangeDependencies");
    if (_devicesBloc == null) {
      _devicesBloc = DevicesBlocProvider.of(context);
      if (_shouldRunOnResume) {
        _shouldRunOnResume = false;
        _onResume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fimber.d("build DeviceListScreenState");
    if (_shouldRunOnResume) {
      _shouldRunOnResume = false;
      _onResume();
    }
    final devicesBloc = _devicesBloc;
    if (devicesBloc == null) {
      throw Exception();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
      ),
      body: StreamBuilder<List<Ergometer>>(
        initialData: devicesBloc.visibleDevices.valueOrNull ?? <Ergometer>[],
        stream: devicesBloc.visibleDevices,
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: devicesBloc.refresh,
          child: DevicesList(devicesBloc, snapshot.data),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Fimber.d("Dispose DeviceListScreenState");
    _onPause();
    super.dispose();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void reassemble() {
    // Fimber.d("reassemble");
    super.reassemble();
  }
}

class DevicesList extends ListView {
  DevicesList(DevicesBloc devicesBloc, List<Ergometer>? devices)
      : super.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                ),
            itemCount: devices?.length ?? 0,
            itemBuilder: (context, i) {
              // Fimber.d("Build row for $i");
              return _buildRow(context, devices![i],
                  _createTapListener(context, devicesBloc, devices[i]));
            });

  static DeviceTapListener _createTapListener(
      BuildContext context, DevicesBloc devicesBloc, Ergometer bleDevice) {
    return () {
      // Fimber.d("clicked device: ${bleDevice.name}");
      // devicesBloc.devicePicker.add(bleDevice);
      Navigator.pop(context, bleDevice);
    };
  }

  static Widget _buildAvatar(BuildContext context, Ergometer device) {
    return CircleAvatar(
        child: Icon(Icons.bluetooth),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white);
  }

  static Widget _buildRow(BuildContext context, Ergometer device,
      DeviceTapListener deviceTapListener) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _buildAvatar(context, device),
      ),
      title: Text(device.name),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Icon(Icons.chevron_right, color: Colors.grey),
      ),
      subtitle: Column(
        children: <Widget>[
          Text(
            device.name.toString(),
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onTap: deviceTapListener,
      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
    );
  }
}
