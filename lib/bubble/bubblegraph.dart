import 'dart:math';

import 'package:circlegraph/bubble/bubble_edge.dart';
import 'package:circlegraph/bubble/circle_tree_view.dart';
import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/tuple.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

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

    CircleTreeView c1 = CircleTreeView(
      tree: first,
      x: 0,
      y: 0,
    );

    _realizedCircles.add(c1);
    _width += first.circleSizeWithPadding;
    _height += first.circleSizeWithPadding;

    if (widget.circleGraphs.length == 1) return;

    // second, if existing
    CircleTree second = widget.circleGraphs[1];

    double r1 = first.circleSizeWithPadding / 2;
    double r2 = second.circleSizeWithPadding / 2;
    double k;

    if (r2 != r1)
      k = sqrt(pow(r1 + r2, 2) - pow(r1 - r2, 2)) + r1 - r2;
    else
      k = 2 * r1;

    CircleTreeView c2 = CircleTreeView(
      tree: second,
      x: k,
      y: 0,
    );

    _realizedCircles.add(c2);

    _width += second.circleSizeWithPadding;
    _height = max(first.circleSizeWithPadding, second.circleSizeWithPadding);

    _workingEdges.add(BubbleEdge(c1, c2));
  }

  void _offsetConstruction(double x, double y) {
    for (int i = 0; i < _realizedCircles.length; i++) {
      CircleTreeView view = _realizedCircles[i];

      _realizedCircles[i] = CircleTreeView(
        tree: view.tree,
        x: view.x + x,
        y: view.y + y,
      );
    }
  }

  ///
  /// place all circles in [widget.circleGraphs] on the plane
  ///
  void _placeCircles() {
    _width = 0;
    _height = 0;
    _realizedCircles.clear();
    _workingEdges.clear();

    _processInitialCircles();

    for (int i = 2; i < widget.circleGraphs.length; i++) {
      CircleTree graph = widget.circleGraphs[i];
      BubbleEdge edge = _workingEdges.first;
      _workingEdges.removeAt(0);

      CircleTreeView aPoint = edge.c1;
      CircleTreeView bPoint = edge.c2;

      int idxA = widget.circleGraphs.indexOf(aPoint.tree);

      Tuple aa = Tuple(
        aPoint.x + aPoint.tree.circleSizeWithPadding / 2,
        aPoint.y + aPoint.tree.circleSizeWithPadding / 2,
      );

      Tuple bb = Tuple(
        bPoint.x + bPoint.tree.circleSizeWithPadding / 2,
        bPoint.y + bPoint.tree.circleSizeWithPadding / 2,
      );

      double a, b, c, alpha;
      a = bPoint.tree.circleSizeWithPadding / 2 +
          graph.circleSizeWithPadding / 2;
      c = aPoint.tree.circleSizeWithPadding / 2 +
          bPoint.tree.circleSizeWithPadding / 2;
      b = aPoint.tree.circleSizeWithPadding / 2 +
          graph.circleSizeWithPadding / 2;

      alpha = acos((pow(a, 2) - pow(b, 2) - pow(c, 2)) / (-2 * b * c));

      Tuple ab = Tuple(
        bb.x - aa.x,
        bb.y - aa.y,
      );

      Tuple acUnscaled = Tuple(
        ab.x * cos(alpha) - ab.y * sin(alpha),
        ab.x * sin(alpha) + ab.y * cos(alpha),
      );

      Tuple ac = Tuple(
        (acUnscaled.x / acUnscaled.magnitude) * b,
        (acUnscaled.y / acUnscaled.magnitude) * b,
      );

      Tuple rootGraphNew = Tuple(
        ac.x + aa.x - graph.circleSizeWithPadding / 2,
        ac.y + aa.y - graph.circleSizeWithPadding / 2,
      );

      CircleTreeView graphView = CircleTreeView(
        tree: graph,
        x: rootGraphNew.x,
        y: rootGraphNew.y,
      );

      _realizedCircles.add(graphView);
      _workingEdges.add(BubbleEdge(aPoint, graphView));

      // check if the point is too far left/up
      if (rootGraphNew.x < 0 || rootGraphNew.y < 0) {
        _offsetConstruction(max(0, -rootGraphNew.x), max(0, -rootGraphNew.y));
        _workingEdges.clear();
        _workingEdges.add(
          BubbleEdge(_realizedCircles[idxA], _realizedCircles.last),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _placeCircles();

    return Container(
      width: _width + 1000,
      height: _height + 1000,
      color: Colors.red,
      child: Stack(
        children: _realizedCircles,
      ),
    );
  }
}
