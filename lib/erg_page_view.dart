import 'package:flutter/material.dart';
import 'package:openergview/erg_grid_view.dart';

class ErgPageView extends StatelessWidget {
  const ErgPageView({Key? key}) : super(key: key);

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
