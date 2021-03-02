import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/tuple.dart';
import 'package:flutter/material.dart';

class CircleTreeView extends StatelessWidget {
  final CircleTree tree;
  final double x;
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

  Tuple get origin => Tuple(x, y);
  Tuple get center => Tuple(
        x + tree.circleSizeWithPadding / 2,
        y + tree.circleSizeWithPadding / 2,
      );
  

}
