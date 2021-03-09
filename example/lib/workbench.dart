import 'package:flutter/material.dart';
import 'package:circlegraph/circlegraph.dart';

import 'color_picker.dart';

class Workbench extends StatelessWidget {
  ///
  /// generate a simple node that holds an integer with a text inside that
  /// contains its index
  ///
  TreeNodeData _nodeWithText(String text) {
    return TreeNodeData<String>(
      child: Text(
        text,
        style: TextStyle(color: ColorPicker.color3),
      ),
      data: text,
      backgroundColor: ColorPicker.color2,
      width: 100,
      height: 50,
    );
  }

  ///
  /// generate a simple node that holds an integer with a text inside that
  /// contains its index
  ///
  TreeNodeData _nodeWithIndex(int i) {
    return _nodeWithText("node $i");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CircleGraph(
          root: _nodeWithText("root"),
          children: [
            _nodeWithIndex(1),
            _nodeWithIndex(2),
            _nodeWithIndex(3),
            _nodeWithIndex(4),
            _nodeWithIndex(5),
            _nodeWithIndex(6),
            _nodeWithIndex(7),
            _nodeWithIndex(8),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
            _nodeWithIndex(9),
          ],
          circleLayout: [
            Circle(50, 4),
            Circle(200, 7),
            Circle(400, -1),
          ],
          circlify: true,
        ),
      ),
    );
  }
}
