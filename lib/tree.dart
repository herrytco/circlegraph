import 'package:circlegraph/tree_node_data.dart';
import 'package:circlegraph/tree_node_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vm;

class Tree extends StatefulWidget {
  final TreeNodeData root;
  final List<TreeNodeData> children;

  final double radius;
  final Color backgroundColor;

  Tree(
      {@required this.root,
      this.children = const [],
      this.radius = 200,
      this.backgroundColor = Colors.red});

  @override
  _TreeState createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  double _width;
  double _height;

  TreeNodeView _root;
  List<TreeNodeView> _realizedNodes = [];

  @override
  void initState() {
    super.initState();

    double lastNodeHeight = -1;
    double lastNodeWidth = -1;
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

        _root = TreeNodeView(data: widget.root, x: 0, y: 0);
        break;
      case 1:
        _width = widget.root.width + widget.radius + lastNodeWidth;
        _height = widget.root.height;

        _root = TreeNodeView(data: widget.root, x: 0, y: 0);
        _realizedNodes.add(
          TreeNodeView(
              data: widget.children[0], x: _width - lastNodeWidth, y: 0),
        );
        break;
      default:
        _width = widget.root.width + 2 * widget.radius + 2 * max(lastNodeWidth, lastNodeWidth);
        _height = widget.root.height + 2 * widget.radius + 2 * max(lastNodeWidth, lastNodeWidth);

        double angleSteps = 360 / widget.children.length;

        double centerX = _width / 2, centerY = _height / 2;

        _root = TreeNodeView(
          data: widget.root,
          x: centerX,
          y: centerY,
        );

        for (int i = 0; i < widget.children.length; i++) {
          TreeNodeData child = widget.children[i];
          double angle = angleSteps * i;

          double nodeX = centerX + widget.radius + _root.data.width / 2 + child.width / 2;
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

          _realizedNodes.add(
            TreeNodeView(
              data: child,
              x: nodeX,
              y: nodeY,
            ),
          );
        }

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      color: widget.backgroundColor,
      child: Stack(
        children: [
          _root,
          for (TreeNodeView view in _realizedNodes) view,
        ],
      ),
    );
  }
}
