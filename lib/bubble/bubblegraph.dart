import 'dart:math';

import 'package:circlegraph/bubble/bubble_edge.dart';
import 'package:circlegraph/bubble/circle_tree_view.dart';
import 'package:circlegraph/circlegraph.dart';
import 'package:flutter/material.dart';

class BubbleGraph extends StatefulWidget {
  @override
  _BubbleGraphState createState() => _BubbleGraphState();

  final List<CircleTree> circleGraphs;

  BubbleGraph(this.circleGraphs) {
    if (circleGraphs.length < 1)
      throw Exception(
          "BubbleGraph needs at least one CircleGraph! 0 were given.");
  }
}

class _BubbleGraphState extends State<BubbleGraph> {
  List<CircleTreeView> _realizedCircles = [];
  List<BubbleEdge> _workingEdges = [];

  double _width = 0;
  double _height = 0;

  ///
  /// manually place the first 2 circles next to each other in the top-left corner
  ///
  void _processInitialCircles() {
    // add the first circle manually
    CircleTree first = widget.circleGraphs.first;
    _realizedCircles.add(
      CircleTreeView(
        tree: first,
        x: 0,
        y: 0,
      ),
    );
    _width += first.circleSizeWithPadding;
    _height += first.circleSizeWithPadding;

    if (widget.circleGraphs.length == 1) return;

    // second, if existing
    CircleTree second = widget.circleGraphs[1];

    double r1 = first.circleSizeWithPadding / 2;
    double r2 = second.circleSizeWithPadding / 2;
    double k;

    if (r2 < r1)
      k = sqrt(pow(r1 + r2, 2) - pow(r1 - r2, 2)) + r1 - r2;
    else if (r2 == r1)
      k = 2 * r1;
    else if (r2 > r1) {
      // TODO
      k = 0;
    }

    _realizedCircles.add(
      CircleTreeView(
        tree: second,
        x: k,
        y: 0,
      ),
    );
    _width += second.circleSizeWithPadding;
    _height = max(first.circleSizeWithPadding, second.circleSizeWithPadding);

    _workingEdges.add(BubbleEdge(first, second));
  }

  ///
  /// place all circles in [widget.circleGraphs] on the plane
  ///
  void _placeCircles() {
    _width = 0;
    _height = 0;
    _realizedCircles.clear();

    _processInitialCircles();
  }

  @override
  Widget build(BuildContext context) {
    _placeCircles();

    return Container(
      width: _width,
      height: _height,
      color: Colors.red,
      child: Stack(
        children: _realizedCircles,
      ),
    );
  }
}
