import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/tuple.dart';
import 'package:flutter/material.dart';

///
/// Realized circle. Holds a CircleTree (meaning it stores also a position)
///
class CircleTreeView extends StatelessWidget {
  ///
  /// graph to draw
  ///
  final CircleTree tree;

  ///
  /// left space between the circle and the containing box
  ///
  final double x;

  ///
  /// top space between the circle and the containing box
  ///
  final double y;

  CircleTreeView({@required this.tree, @required this.x, @required this.y});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: tree,
    );
  }

  ///
  /// top-left corner of the sqaure containing the circle
  ///
  Tuple get origin => Tuple(x, y);

  ///
  /// center position of the circle
  ///
  Tuple get center => Tuple(
        x + tree.circleSizeWithPadding / 2,
        y + tree.circleSizeWithPadding / 2,
      );
}
