import 'package:circlegraph/tree_node_data.dart';
import 'package:circlegraph/tree_node_view.dart';
import 'package:circlegraph/tree_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vm;

class CircleTree extends StatefulWidget {
  final TreeNodeData root;
  final List<TreeNodeData> children;

  final double radius;
  final Color backgroundColor;

  final Widget Function(TreeNodeData node, int data) tooltipBuilder;

  void test() {}

  CircleTree({
    @required this.root,
    this.children = const [],
    this.radius = 200,
    this.backgroundColor = Colors.red,
    this.tooltipBuilder,
  }) {
    // add an edge from root to each child
    for (TreeNodeData child in children) root.addEdgeTo(child);
  }

  @override
  _CircleTreeState createState() => _CircleTreeState();
}

class _CircleTreeState extends State<CircleTree> {
  double _width;
  double _height;

  double _nodeWidth;
  double _nodeHeight;

  TreeNodeView _root;
  List<TreeNodeView> _realizedNodes = [];

  TreeNodeData _currentlyHoveredNode;

  void reportMouseOver(TreeNodeData node) {
    if (node != _currentlyHoveredNode) {
      _currentlyHoveredNode = node;

      print("nice mouseover over $node");
    }
  }

  void _resetData() {
    _realizedNodes = [];
    _root = null;
    for (TreeNodeData node in widget.children) {
      node.position = null;
      node.clearEdges();
    }
  }

  ///
  /// calculate the size of the container containing the graph. it uses the
  /// width of root and child-nodes as well as the radius the circle should have
  ///
  void _calcTreeWidgetSize() {
    double lastNodeHeight = -1, lastNodeWidth = -1;

    for (TreeNodeData node in widget.children) {
      if (lastNodeWidth == -1) {
        lastNodeWidth = node.width;
        lastNodeHeight = node.height;
      } else {
        if (lastNodeWidth != node.width || lastNodeHeight != node.height)
          throw Exception("All nodes must have the same size!");
      }
    }

    switch (widget.children.length) {
      case 0:
        _width = widget.root.width;
        _height = widget.root.height;
        break;
      case 1:
        _width = widget.root.width + widget.radius + lastNodeWidth;
        _height = widget.root.height;
        break;
      case 2:
        _width = widget.root.width +
            2 * widget.radius +
            2 * max(lastNodeWidth, lastNodeWidth);
        _height = widget.root.height;
        break;
      default:
        _width = widget.root.width +
            2 * widget.radius +
            2 * max(lastNodeWidth, lastNodeWidth);
        _height = widget.root.height +
            2 * widget.radius +
            2 * max(lastNodeWidth, lastNodeWidth);
        break;
    }

    _nodeWidth = lastNodeWidth;
    _nodeHeight = lastNodeHeight;
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
          y: widget.root.height / 2,
          containingTree: widget,
          onHover: reportMouseOver,
        );

        break;
      case 1:
        _root = TreeNodeView(
          data: widget.root,
          x: widget.root.width / 2,
          y: widget.root.height / 2,
          containingTree: widget,
          onHover: reportMouseOver,
        );

        TreeNodeView childRealization = TreeNodeView(
          data: widget.children[0],
          x: _width - _nodeWidth / 2,
          y: _nodeHeight / 2,
          containingTree: widget,
          onHover: reportMouseOver,
        );

        _realizedNodes.add(childRealization);
        break;
      default:
        double angleSteps = 360 / widget.children.length;
        double centerX = _width / 2, centerY = _height / 2;

        _root = TreeNodeView(
          data: widget.root,
          x: centerX,
          y: centerY,
          containingTree: widget,
          onHover: reportMouseOver,
        );

        for (int i = 0; i < widget.children.length; i++) {
          TreeNodeData child = widget.children[i];
          double angle = angleSteps * i;

          double nodeX =
              centerX + widget.radius + _root.data.width / 2 + child.width / 2;
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
            onHover: reportMouseOver,
          );

          _realizedNodes.add(childRealization);
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build tree with root and ${widget.children.length} children.");

    _resetData();
    _calcTreeWidgetSize();
    _calcNodePositions();

    return Container(
      width: _width,
      height: _height,
      color: widget.backgroundColor,
      child: CustomPaint(
        painter: TreePainter(tree: widget),
        child: Stack(
          children: [
            _root,
            for (TreeNodeView view in _realizedNodes) view,
          ],
        ),
      ),
    );
  }
}
