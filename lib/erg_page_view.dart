import 'dart:async';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/erg_grid_view.dart';
import 'package:openergview/settings_screen.dart';
import 'package:provider/provider.dart';

import 'data_tile.dart';
import 'devices_list/devices_bloc_provider.dart';
import 'devices_list/devices_list_view.dart';
import 'erg_staggered_view.dart';
import 'src/ergometerstore.dart';
import 'utils.dart';

class ErgPageView extends StatefulWidget {
  ErgPageView({super.key});

  @override
  _ErgPageViewState createState() => _ErgPageViewState();
}

///depends on [ErgometerStore]
class _ErgPageViewState extends State<ErgPageView>
    with SingleTickerProviderStateMixin {
  int _pageCount = 3;
  int _currentIndex = 0;

  ErgometerConnectionState lastConnectionState =
      ErgometerConnectionState.disconnected;

  Stream<ErgometerConnectionState>? _ergConnectionStatusStream;

  StreamSubscription<ErgometerConnectionState>? _ergConnectionStatus;

  late ErgometerStore? ergstore;

  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: _pageCount, initialIndex: _currentIndex, vsync: this);

    ergstore = Provider.of<ErgometerStore>(context);

    if (ergstore != null && ergstore!.erg != null) {
      _ergConnectionStatusStream =
          ergstore!.erg!.connectAndDiscover().asBroadcastStream(
        onCancel: (controller) {
          print('Stream paused');
          controller.pause();
        },
        onListen: (controller) async {
          if (controller.isPaused) {
            print('Stream resumed');
            controller.resume();
          }
        },
      );

      _ergConnectionStatus = _ergConnectionStatusStream
          ?.listen((ErgometerConnectionState connectionState) {
        lastConnectionState = connectionState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);

    return SafeArea(
        child: Scaffold(
            body: PageView(
              /// [PageView.scrollDirection] defaults to [Axis.horizontal].
              /// Use [Axis.vertical] to scroll vertically.
              controller: pageController,
              onPageChanged: (newIndex) {
                setState(() {
                  _currentIndex = newIndex;
                  tabController.animateTo(newIndex);
                });
              },
              children: <Widget>[
                ErgStaggeredView(children: [
                  DataTile(
                      title: "distance",
                      defaultValue: 1,
                      stream: ergstore?.erg
                          ?.monitorForData({"general.distance"}).map((event) {
                        var data = event["general.distance"] as double;
                        print(data);
                        return data;
                      })),
                  DataTile(
                    title: "Drive Length",
                    defaultValue: 1.27,
                    unit: "m",
                    decimals: 2,
                  )
                ]),
                ErgGridView(
                  children: [
                    DataTile(
                        title: "distance",
                        defaultValue: 1,
                        stream: ergstore?.erg
                            ?.monitorForData({"general.distance"}).map((event) {
                          var data = event["general.distance"] as double;
                          print(data);
                          return data;
                        })),
                    DataTile(
                      title: "Drive Length",
                      defaultValue: 1.27,
                      unit: "m",
                      decimals: 2,
                    ),
                    DataTile(
                      title: "Average Force",
                      defaultValue: 264,
                      unit: "lb",
                    ),
                    DataTile(title: "Drag Factor", defaultValue: 218),
                    DataTile(
                      title: "Drive Speed",
                      defaultValue: 12.10,
                      unit: "m/s",
                      decimals: 2,
                    ),
                    DataTile(title: "Peak Force", defaultValue: 341, unit: "lb")
                  ],
                ),
                Center(
                  child: Text('First Page'),
                ),
                ErgGridView(
                  children: [
                    DataTile(title: "test", defaultValue: 1),
                    DataTile(title: "test", defaultValue: 2),
                    DataTile(title: "test", defaultValue: 3),
                    DataTile(title: "test", defaultValue: 4),
                    DataTile(title: "test", defaultValue: 5),
                    DataTile(title: "test", defaultValue: 6)
                  ],
                )
              ],
            ),
            bottomNavigationBar: Container(
              height: kBottomNavigationBarHeight,
              decoration: BoxDecoration(
                gradient: getDarkGradient(context),
                color: Colors.indigo,
              ),
              child: BottomAppBar(
                color: Colors.transparent,
                child: IconTheme(
                    data: IconThemeData(
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: Row(
                      children: <Widget>[
                        StreamBuilder<ErgometerConnectionState>(
                            stream: _ergConnectionStatusStream,
                            initialData: lastConnectionState,
                            builder: (BuildContext context,
                                AsyncSnapshot<ErgometerConnectionState>
                                    snapshot) {
                              if (snapshot.hasError) {
                                return const Text(
                                  "Error",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.red),
                                );
                              } else {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return const Text(
                                      "Please Connect PM",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    );
                                  case ConnectionState.waiting:
                                    return const CircularProgressIndicator();
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    switch (snapshot.data) {
                                      case ErgometerConnectionState.connecting:
                                        return const Text(
                                          "Connecting...",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.yellow),
                                        );
                                      case ErgometerConnectionState.connected:
                                        return const Text(
                                          "Connected to erg",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.green),
                                        );
                                      case ErgometerConnectionState
                                            .disconnected:
                                        return const Text(
                                          "Disconnected",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red),
                                        );
                                      default:
                                        return const Text(
                                          "Unknown",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white),
                                        );
                                    }
                                }
                              }
                            }),
                        const Spacer(),
                        if (isPointerDevice(context))
                          IconButton(
                            tooltip: 'Previous',
                            icon: const Icon(Icons.arrow_back),
                            disabledColor: Colors.grey,
                            onPressed: _currentIndex != 0
                                ? () => setState(() {
                                      pageController.animateToPage(
                                          _currentIndex - 1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    })
                                : null,
                          ),
                        TabPageSelector(
                          color: Colors.grey,
                          borderStyle: BorderStyle.none,
                          selectedColor: Colors.white,
                          controller: tabController,
                        ),
                        if (isPointerDevice(context))
                          IconButton(
                            tooltip: 'Next',
                            icon: const Icon(Icons.arrow_forward),
                            disabledColor: Colors.grey,
                            onPressed: _currentIndex != _pageCount - 1
                                ? () => setState(() {
                                      pageController.animateToPage(
                                          _currentIndex + 1,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    })
                                : null,
                          ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Settings',
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingsPageView()));
                          },
                        ),
                      ],
                    )),
              ),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
