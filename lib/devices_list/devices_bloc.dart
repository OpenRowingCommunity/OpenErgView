import 'dart:async';
import 'dart:io';

// import 'package:fimber/fimber.dart';
// import '../model/ble_device.dart';
// import '../repository/device_repository.dart';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class DevicesBloc {
  final List<Ergometer> bleDevices = <Ergometer>[];

  BehaviorSubject<List<Ergometer>> _visibleDevicesController =
      BehaviorSubject<List<Ergometer>>.seeded(<Ergometer>[]);

  // StreamController<Ergometer> _devicePickerController =
  //     StreamController<Ergometer>();

  StreamSubscription<Ergometer>? _scanSubscription;
  // StreamSubscription<Ergometer>? _devicePickerSubscription;

  ValueStream<List<Ergometer>> get visibleDevices =>
      _visibleDevicesController.stream;

  // Sink<Ergometer> get devicePicker => _devicePickerController.sink;

  // final DeviceRepository _deviceRepository;
  final ErgBleManager _bleManager;

  // Stream<Ergometer> get pickedDevice => _deviceRepository.pickedDevice
  //     .skipWhile((bleDevice) => bleDevice == null)
  //     .cast<Ergometer>();

  DevicesBloc({ErgBleManager? bleManager})
      : _bleManager = bleManager ?? ErgBleManager() {
    print("Init devices bloc");
    bleDevices.clear();

    _checkPermissions()
        // .then((_) => _checkPermissions())
        // .catchError((e) => Fimber.d("Permission check error", ex: e))
        // .then((_) => _waitForBluetoothPoweredOn())
        .then((_) => _startScan());

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController =
          BehaviorSubject<List<Ergometer>>.seeded(<Ergometer>[]);
    }
  }

  // void _handlePickedDevice(Ergometer bleDevice) {
  //   _deviceRepository.pickDevice(bleDevice);
  // }

  void dispose() {
    // Fimber.d("cancel _devicePickerSubscription");
    // _devicePickerSubscription?.cancel();
    _visibleDevicesController.close();
    // _devicePickerController.close();
    _scanSubscription?.cancel();
  }

  void init() {
    // if (_devicePickerController.isClosed) {
    //   _devicePickerController = StreamController<Ergometer>();
    // }

    // Fimber.d(" listen to _devicePickerController.stream");
    // _devicePickerSubscription =
    //     _devicePickerController.stream.listen(_handlePickedDevice);
  }

  // Future<void> maybeCreateClient() async {
  // Fimber.d('Checking if client exists...');
  // final clientAlreadyExists = await _bleManager.isClientCreated();
  // // Fimber.d('Client exists: $clientAlreadyExists');

  // if (clientAlreadyExists) {
  //   // Fimber.d("Client already exists");
  //   return Future.value();
  // }

  // Fimber.d("Create client");

  // return _bleManager.init();
  //     .createClient(
  //         restoreStateIdentifier: "example-restore-state-identifier",
  //         restoreStateAction: (peripherals) {
  //           peripherals.forEach((peripheral) {
  //             // Fimber.d("Restored peripheral: ${peripheral.name}");
  //           });
  //         })
  //     .catchError((e) {
  //   // return Fimber.d("Couldn't create BLE client", ex: e);
  // });
  // }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var locGranted = await Permission.location.isGranted;
      if (locGranted == false) {
        locGranted = (await Permission.location.request()).isGranted;
      }
      if (locGranted == false) {
        return Future.error(Exception("Location permission not granted"));
      }
    }
  }

  // Future<void> _waitForBluetoothPoweredOn() async {
  //   Completer completer = Completer();
  //   StreamSubscription<BluetoothState>? subscription;
  //   subscription = _bleManager
  //       .observeBluetoothState(emitCurrentValue: true)
  //       .listen((bluetoothState) async {
  //     if (bluetoothState == BluetoothState.POWERED_ON &&
  //         !completer.isCompleted) {
  //       await subscription?.cancel();
  //       completer.complete();
  //     }
  //   });

  //   return completer.future;
  // }

  void _startScan() {
    // Fimber.d("Ble start scan");
    _scanSubscription = _bleManager.startErgScan().listen((ergometer) {
      if (!bleDevices.contains(ergometer)) {
        // Fimber.d(
        print('found new device ${ergometer.name} (${ergometer.id})');
        bleDevices.add(ergometer);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  Future<void> refresh() async {
    await _scanSubscription?.cancel();
    bleDevices.clear();

    _visibleDevicesController.add(bleDevices.sublist(0));

    await _checkPermissions().then((_) => _startScan());
    // .catchError((e) => Fimber.d("Couldn't refresh", ex: e));
  }
}
