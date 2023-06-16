import 'package:flutter/material.dart';
import 'package:openergview/constants.dart';
import 'package:openergview/erg_grid_view.dart';

class ErgPageView extends StatefulWidget {
  ErgPageView({Key? key}) : super(key: key);

  @override
  _ErgPageViewState createState() => _ErgPageViewState();
}

class _ErgPageViewState extends State<ErgPageView> {
  int _currentIndex = 0;

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
            _currentIndex = newIndex;
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
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.white),
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "1"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "2"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "3")
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (newIndex) {
            controller.animateToPage(newIndex,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }
}
