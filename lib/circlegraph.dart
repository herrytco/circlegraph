library circlegraph;

export 'package:circlegraph/circle/tree_node_data.dart';
export 'package:circlegraph/circle/circle.dart';
export 'package:circlegraph/bubble/bubblegraph.dart';

import 'package:circlegraph/circle/circle.dart';
import 'package:circlegraph/circle/graph_tooltip.dart';
import 'package:circlegraph/tuple.dart';
import 'package:circlegraph/circle/tree_node_data.dart';
import 'package:circlegraph/circle/tree_node_view.dart';
import 'package:circlegraph/circle/tree_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vm;

///
/// A tree with one node in the center and a number of nodes placed around it
///
class CircleGraph extends StatefulWidget {
  ///
  /// Central node, has a connection to each node specified in children
  ///
  final TreeNodeData root;

  ///
  /// Nodes placed around the central rootnode
  ///
  final List<TreeNodeData> children;

  ///
  /// distance between root and child nodes
  ///
  double get radius {
    double maxRadius = 0;

    for (Circle c in circleData) if (c.radius > maxRadius) maxRadius = c.radius;

    return maxRadius;
  }

  ///
  /// background color of the graph including padding
  ///
  final Color backgroundColor;

  ///
  /// color of the lines between the nodes
  ///
  final Color edgeColor;

  ///
  /// space between the graph and the edge of the containing box
  ///
  final EdgeInsets padding;

  ///
  /// should the graph placed inside of an actual circle?
  ///
  final bool circlify;

  ///
  /// dimensions of the child nodes. These are the same for all child nodes
  /// in the graph
  ///
  Tuple get nodeDimensions {
    if (children.length > 0)
      return Tuple(children.first.width, children.first.height);

    return null;
  }

  ///
  /// dimensions of the root node.
  ///
  Tuple get rootDimensions {
    return Tuple(root.width, root.height);
  }

  ///
  /// Larger side of the Contaienr which contains the graph. Padding is not included.
  ///
  double get sizeWithoutPadding {
    switch (children.length) {
      case 0:
        return rootDimensions.largestElement;
      case 1:
        return max(
          rootDimensions.x + radius + nodeDimensions.x,
          rootDimensions.y,
        );
        break;
      default:
        return rootDimensions.largestElement +
            2 * radius +
            2 * nodeDimensions.largestElement;
    }
  }

  ///
  /// Larger side of the Container which contains the graph, Padding included.
  ///
  double get sizeWithPadding {
    return sizeWithoutPadding +
        max(
          padding.top + padding.bottom,
          padding.left + padding.right,
        );
  }

  ///
  /// If the graph is circlified, the effective size grows by sqrt(2), the value
  /// is retrieved via this getter.
  ///
  double get circleSizeWithPadding {
    return sizeWithPadding * sqrt(2);
  }

  ///
  /// If the graph is circlified, the effective size grows by sqrt(2), the value
  /// is retrieved via this getter.
  ///
  double get circleSizeWithoutPadding {
    return sizeWithoutPadding * sqrt(2);
  }

  ///
  /// Height of the box which contains the graph. Padding is included.
  ///
  double get height {
    double yPadding = padding.top + padding.bottom;

    return yPadding + sizeWithoutPadding;
  }

  ///
  /// Width of the box which contains the graph. Padding is included.
  ///
  double get width {
    double xPadding = padding.left + padding.right;

    return xPadding + sizeWithoutPadding;
  }

  ///
  /// builds the tooltip widget at [node]
  ///
  final Widget Function(TreeNodeData node, int data) tooltipBuilder;

  final List<Circle> circleData;

  CircleGraph({
    @required this.root,
    this.children = const [],
    double radius = 200,
    this.backgroundColor =
        const Color.fromRGBO(154, 212, 214, 1), // powder blue
    this.edgeColor = const Color.fromRGBO(139, 30, 63, 1), // claret (red-ish),
    this.padding = EdgeInsets.zero,
    this.tooltipBuilder,
    this.circlify = false,
    circleLayout = const [],
  }) : circleData = circleLayout.length == 0 ? [] : circleLayout {
    if (circleData.length == 0 || circleData.last.radius != -1)
      circleData.add(Circle(radius, -1));

    // check if nodes are the same size
    double lastNodeWidth = -1, lastNodeHeight = -1;
    for (TreeNodeData node in children) {
      if (lastNodeWidth == -1) {
        lastNodeWidth = node.width;
        lastNodeHeight = node.height;
      } else {
        if (lastNodeWidth != node.width || lastNodeHeight != node.height)
          throw Exception("All nodes must have the same size!");
      }
    }

    // add an edge from root to each child
    for (TreeNodeData child in children) {
      root.addEdgeTo(
        child,
        edgeColor: edgeColor,
      );
    }
  }

  @override
  _CircleGraphState createState() => _CircleGraphState();
}

class _CircleGraphState extends State<CircleGraph> {
  ///
  /// Realized root node (in the center of the graph). Contains final x and y
  /// coordinates.
  ///
  TreeNodeView _root;

  ///
  /// Realized child nodes (on the edge of the graph). Contains final x and y
  /// coordinates.
  ///
  List<TreeNodeView> _realizedNodes = [];

  ///
  /// If the cursor hovers over a node in the graph (including the root) this
  /// value will be set.
  ///
  TreeNodeData _currentlyHoveredNode;

  ///
  /// Getter for the currently hovered node.
  ///
  TreeNodeData getCurrentlyHoveredNode() => _currentlyHoveredNode;

  ///
  /// Called when the background is hovered. Resets the currently hovered node
  /// and discards the tooltip in the process.
  ///
  void _resetMouseOver() {
    setState(() {
      _currentlyHoveredNode = null;
    });
  }

  ///
  /// called when the mouse is currently on top of a node. Sets the node as the
  /// currently hovered node which will display the tooltip.
  ///
  void _reportMouseOver(TreeNodeData node) {
    if (node != _currentlyHoveredNode) {
      setState(() {
        _currentlyHoveredNode = node;
      });
    }
  }

  ///
  /// clears the inputdata from realized data and removes edges as they get recomputed
  /// with the latest data
  ///
  void _resetData() {
    _realizedNodes = [];
    _root = null;
    for (TreeNodeData node in widget.children) {
      node.position = null;
      node.clearEdges();
    }
  }

  ///
  /// calculate the effective position each node has in the coordinate system
  ///
  void _calcNodePositions() {
    switch (widget.children.length) {
      case 0:
        _root = TreeNodeView(
          data: widget.root,
          x: widget.root.width / 2,
          y: widget.sizeWithoutPadding / 2,
          containingTree: widget,
          onHover: _reportMouseOver,
        );

        break;
      case 1:
        _root = TreeNodeView(
          data: widget.root,
          x: widget.root.width / 2,
          y: widget.sizeWithoutPadding / 2,
          containingTree: widget,
          onHover: _reportMouseOver,
        );

        TreeNodeView childRealization = TreeNodeView(
          data: widget.children[0],
          x: widget.sizeWithoutPadding - widget.nodeDimensions.x / 2,
          y: widget.sizeWithoutPadding / 2,
          containingTree: widget,
          onHover: _reportMouseOver,
        );

        _realizedNodes.add(childRealization);
        break;
      default:
        double centerX = widget.sizeWithoutPadding / 2,
            centerY = widget.sizeWithoutPadding / 2;

        _root = TreeNodeView(
          data: widget.root,
          x: centerX,
          y: centerY,
          containingTree: widget,
          onHover: _reportMouseOver,
        );

        int i = 0;

        for (Circle circle in widget.circleData) {
          int nodesInCurrentCircle = 0;

          double angleSteps;

          if (circle.nElements > 0)
            angleSteps = 360 / circle.nElements;
          else
            angleSteps = 360 / (widget.children.length - i);
          double angleOffset =
              widget.circleData.indexOf(circle) % 2 == 0 ? 0 : angleSteps / 2;

          while (nodesInCurrentCircle < circle.nElements ||
              circle.nElements == -1) {
            if (i == widget.children.length) break;

            TreeNodeData child = widget.children[i];
            double angle = angleSteps * nodesInCurrentCircle + angleOffset;

            double nodeX = centerX +
                circle.radius +
                _root.data.width / 2 +
                child.width / 2;
            double nodeY = centerY;

            // translate rotation origin to (0/0)
            nodeX -= centerX;
            nodeY -= centerY;

            // perform rotation according to https://academo.org/demos/rotation-about-point/
            double cosinus = cos(vm.radians(angle));
            double sinus = sin(vm.radians(angle));

            double xPrime = nodeX * cosinus - nodeY * sinus;
            double yPrime = nodeY * cosinus - nodeX * sinus;

            nodeX = xPrime;
            nodeY = yPrime;

            // translate origin back to (centerX/centerY)
            nodeX += centerX;
            nodeY += centerY;

            TreeNodeView childRealization = TreeNodeView(
              data: child,
              x: nodeX,
              y: nodeY,
              containingTree: widget,
              onHover: _reportMouseOver,
            );

            _realizedNodes.add(childRealization);

            i++;
            nodesInCurrentCircle++;

            if (nodesInCurrentCircle == circle.nElements) break;
          }
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _resetData();
    _calcNodePositions();

    Widget graph = Align(
      alignment: Alignment.center,
      child: Container(
        height: widget.sizeWithoutPadding,
        width: widget.sizeWithoutPadding,
        color: widget.backgroundColor,
        child: Stack(
          children: [
            Listener(
              onPointerHover: (event) => _resetMouseOver(),
              child: Container(
                constraints: BoxConstraints.expand(),
                child: CustomPaint(
                  painter: TreePainter(tree: widget),
                ),
              ),
            ),
            _root,
            for (TreeNodeView view in _realizedNodes) view,
            _currentlyHoveredNode != null
                ? GraphTooltip(
                    getCurrentlyHoveredNode,
                    widget.tooltipBuilder != null
                        ? widget.tooltipBuilder(
                            _currentlyHoveredNode, _currentlyHoveredNode.data)
                        : SizedBox(),
                    widget.sizeWithoutPadding,
                    widget.sizeWithoutPadding,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );

    return widget.circlify
        ? Container(
            width: widget.circleSizeWithPadding,
            height: widget.circleSizeWithPadding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: graph,
          )
        : Container(
            width: widget.sizeWithPadding,
            height: widget.sizeWithPadding,
            color: widget.backgroundColor,
            child: graph,
          );
  }
}
