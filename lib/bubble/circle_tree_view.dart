import 'package:circlegraph/circlegraph.dart';
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
}
