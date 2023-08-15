import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/erg_grid_view.dart';
import 'package:openergview/settings_page_view.dart';

import 'utils.dart';

class ErgPageView extends StatefulWidget {
  final Ergometer erg;
  ErgPageView({Key? key, required this.erg}) : super(key: key);

  @override
  _ErgPageViewState createState() => _ErgPageViewState();
}

class _ErgPageViewState extends State<ErgPageView>
    with SingleTickerProviderStateMixin {
  int _pageCount = 3;
  int _currentIndex = 0;

  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: _pageCount, initialIndex: _currentIndex, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);

    return Scaffold(
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
          children: const <Widget>[
            ErgGridView(),
            Center(
              child: Text('First Page'),
            ),
            ErgGridView()
          ],
        ),
        bottomNavigationBar: Container(
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
                    Text(
                      "status text",
                      style: TextStyle(fontSize: 32.0, color: Colors.white),
                    ),
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
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsPageView()));
                      },
                    ),
                  ],
                )),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
