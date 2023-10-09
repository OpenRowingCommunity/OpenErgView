import 'dart:async';

import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/settings_screen.dart';
import 'package:provider/provider.dart';

import 'src/components/data_tile.dart';
import 'src/tabviews/erg_grid_view.dart';
import 'src/tabviews/erg_staggered_view.dart';
import 'src/ergometerstore.dart';
import 'utils.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

///depends on [ErgometerStore]
class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  //TODO: remove this magic number somehow
  int _pageCount = 3;
  int _currentIndex = 0;

  ErgometerConnectionState lastConnectionState =
      ErgometerConnectionState.disconnected;

  Stream<ErgometerConnectionState>? _ergConnectionStatusStream;

  StreamSubscription<ErgometerConnectionState>? _ergConnectionStatus;

  late ErgometerStore? ergstore;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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

  List<Widget> _buildPageIndicator(length, selectedIndex) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      // list.add(i == selectedIndex ? TabIndicator(true) : TabIndicator(false));
      list.add(i == selectedIndex
          ? const TabPageSelectorIndicator(
              backgroundColor: Colors.white,
              borderColor: Colors.white,
              size: 12,
              borderStyle: BorderStyle.solid,
            )
          : const TabPageSelectorIndicator(
              backgroundColor: Colors.grey,
              borderColor: Colors.grey,
              size: 12,
              borderStyle: BorderStyle.solid,
            ));
    }
    return list;
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
                });
              },
              children: <Widget>[
                ErgStaggeredView(children: [
                  DataTile(
                      title: "distance",
                      defaultValue: 1,
                      stream:
                          getDoubleDataStream(ergstore, "general.distance")),
                  DataTile(
                      title: "Drive Length",
                      defaultValue: 1.27,
                      unit: "m",
                      decimals: 2,
                      stream:
                          getDoubleDataStream(ergstore, "stroke.drive_length"))
                ]),
                ErgGridView(
                  children: [
                    DataTile(
                        title: "distance",
                        defaultValue: 1,
                        stream:
                            getDoubleDataStream(ergstore, "general.distance")),
                    DataTile(
                        title: "Drive Length",
                        defaultValue: 1.27,
                        unit: "m",
                        decimals: 2,
                        stream: getDoubleDataStream(
                            ergstore, "stroke.drive_length")),
                    DataTile(
                        title: "Average Force",
                        defaultValue: 264,
                        unit: "lb",
                        stream: getDoubleDataStream(
                            ergstore, "stroke.drive_force.average")),
                    DataTile(title: "Drag Factor", defaultValue: 218),
                    //TODO: drive length over drive time
                    DataTile(
                      title: "Drive Speed",
                      defaultValue: 12.10,
                      unit: "m/s",
                      decimals: 2,
                    ),
                    DataTile(
                        title: "Peak Force",
                        defaultValue: 341,
                        unit: "lb",
                        stream: getDoubleDataStream(
                            ergstore, "stroke.drive_force.max"))
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
                        Row(
                            children:
                                _buildPageIndicator(_pageCount, _currentIndex)),
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
                                builder: (context) => SettingsScreen()));
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
  }
}
