import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/erg_grid_view.dart';

class ErgPageView extends StatefulWidget {
  ErgPageView({Key? key}) : super(key: key);

  @override
  _ErgPageViewState createState() => _ErgPageViewState();
}

class _ErgPageViewState extends State<ErgPageView> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    return Scaffold(
        body: PageView(
          /// [PageView.scrollDirection] defaults to [Axis.horizontal].
          /// Use [Axis.vertical] to scroll vertically.
          controller: controller,
          onPageChanged: (newIndex) {
            setState(() {
              // _currentIndex = newIndex;
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
                    //TabPageSelector
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
}
