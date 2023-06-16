import 'package:flutter/material.dart';
import 'package:openergview/erg_grid_view.dart';

class ErgPageView extends StatefulWidget {
  ErgPageView({Key? key}) : super(key: key);

  @override
  _ErgPageViewState createState() => _ErgPageViewState();
}

class _ErgPageViewState extends State<ErgPageView> {

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: const <Widget>[
        ErgGridView(),
        Center(
          child: Text('First Page'),
        ),
        ErgGridView()
      ],
    );
  }
}
