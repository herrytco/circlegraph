import 'dart:math';

import 'package:circlegraph/bubble/bubble_edge.dart';
import 'package:circlegraph/bubble/circle_tree_view.dart';
import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/data_stack.dart';
import 'package:circlegraph/tuple.dart';
import 'package:flutter/material.dart';

///
/// Places a number of CircleGraphs organically next to each other
///
class BubbleGraph extends StatefulWidget {
  @override
  _BubbleGraphState createState() => _BubbleGraphState();

  ///
  /// graphs to draw
  ///
  final List<CircleGraph> circleGraphs;

  ///
  /// background color of the box containing the graph
  ///
  final Color backgroundColor;

  ///
  /// empty space from the edge of the widget to the start of the actual
  /// circles
  ///
  final EdgeInsets padding;

  ///
  /// Creates a new bubblegraph containing [circleGraphs] inside. The dimensions
  /// of the widget are constant.
  ///
  BubbleGraph(
    this.circleGraphs, {
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
  }) {
    if (circleGraphs.length < 1)
      throw Exception(
          "BubbleGraph needs at least one CircleGraph! 0 were given.");
  }
}

class _BubbleGraphState extends State<BubbleGraph> {
  ///
  /// already placed circles, holding their x/y positions
  ///
  List<CircleTreeView> _realizedCircles = [];

  ///
  /// edges beneath 2 neighbour cirles where a new circle could be placed
  ///
  DataStack<BubbleEdge> _workingEdges = DataStack();

  ///
  /// width of the box containing the graph
  ///
  double _width = 0;

  ///
  /// height of the box containing the graph
  ///
  double _height = 0;

  ///
  /// manually place the first 2 circles next to each other in the top-left corner
  ///
  void _processInitialCircles() {
    // add the first circle manually
    CircleGraph first = widget.circleGraphs.first;

    CircleTreeView c1 = CircleTreeView(
      tree: first,
      x: 0,
      y: 0,
    );

    _realizedCircles.add(c1);

    if (widget.circleGraphs.length == 1) {
      _recalculateDimensions();
      return;
    }

    // second, if existing
    CircleGraph second = widget.circleGraphs[1];

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

    _workingEdges.push(BubbleEdge(c1, c2));
    _recalculateDimensions();
  }

  ///
  /// move the whole graph [x] to the right [y] downwards
  ///
  void _offsetConstruction(double x, double y) {
    for (int i = 0; i < _realizedCircles.length; i++) {
      CircleTreeView view = _realizedCircles[i];

      CircleTreeView viewReplacement = CircleTreeView(
        tree: view.tree,
        x: view.x + x,
        y: view.y + y,
      );

      _realizedCircles[i] = viewReplacement;

      // update edges with new data
      for (BubbleEdge edge in _workingEdges.data)
        edge.replaceCircleTreeView(viewReplacement);
    }
  }

  ///
  /// checks if the origin of [view] is outside of the visible area (negative)
  /// and offset the whole graph if so
  ///
  void _updateSizeForNewGraphView(CircleTreeView view) {
    // top-left corner of circleGraph
    Tuple rootGraph = view.origin;

    // check if the point is too far left/up and if so, shift the whole
    // BubbleGraph down/right
    if (rootGraph.x < 0 || rootGraph.y < 0)
      _offsetConstruction(max(0, -rootGraph.x), max(0, -rootGraph.y));
  }

  ///
  /// resets width/height of the box containing all circles and iterates through
  /// [_realizedCircle] to find the maximum dimensions
  ///
  void _recalculateDimensions() {
    _height = 0;
    _width = 0;

    for (CircleTreeView treeView in _realizedCircles) {
      Tuple bottomRight = treeView.origin
        ..addScalarTo(treeView.tree.circleSizeWithPadding);

      if (bottomRight.x > _width) _width = bottomRight.x;
      if (bottomRight.y > _height) _height = bottomRight.y;
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
      CircleGraph graph = widget.circleGraphs[i];
      BubbleEdge edge = _workingEdges.pop();

      CircleTreeView aPoint = edge.c1;
      CircleTreeView bPoint = edge.c2;

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

      // check for overlap with existing circles
      bool circleCollidesWithAnotherCircle = false;

      for (CircleTreeView existingCircle in _realizedCircles) {
        double radiusOther =
            (existingCircle.tree.circleSizeWithPadding / 2) * .98;
        Tuple centerOther = Tuple(
          existingCircle.x + radiusOther,
          existingCircle.y + radiusOther,
        );

        double radiusThis = (graph.circleSizeWithPadding / 2) * .98;
        Tuple centerThis = Tuple(
          graphView.x + radiusThis,
          graphView.y + radiusThis,
        );

        Tuple vectorBetweenCenters = Tuple(
          centerOther.x - centerThis.x,
          centerOther.y - centerThis.y,
        );

        if (max(radiusThis, radiusOther) - min(radiusThis, radiusOther) <
                vectorBetweenCenters.magnitude &&
            vectorBetweenCenters.magnitude < radiusThis + radiusOther) {
          circleCollidesWithAnotherCircle = true;
          break;
        }
      }

      if (circleCollidesWithAnotherCircle) {
        i--;
        continue;
      }

      _realizedCircles.add(graphView);
      _workingEdges.push(BubbleEdge(graphView, bPoint));
      _workingEdges.push(BubbleEdge(aPoint, graphView));

      _updateSizeForNewGraphView(graphView);
    }

    _recalculateDimensions();
  }

  @override
  Widget build(BuildContext context) {
    _placeCircles();

    return Container(
      color: widget.backgroundColor,
      width: _width + widget.padding.left + widget.padding.right,
      height: _height + widget.padding.top + widget.padding.bottom,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: _width,
          height: _height,
          color: widget.backgroundColor,
          child: Stack(
            children: _realizedCircles,
          ),
        ),
      ),
    );
  }
}
