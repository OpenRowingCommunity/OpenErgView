import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/erg_grid_view.dart';

class ErgPageView extends StatefulWidget {
  ErgPageView({Key? key}) : super(key: key);

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
                    // IconButton(
                    //   tooltip: 'Open navigation menu',
                    //   icon: const Icon(Icons.menu),
                    //   onPressed: () {},
                    // ),
                    const Spacer(),
                    TabPageSelector(
                      color: Colors.black38,
                      controller: tabController,
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
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
