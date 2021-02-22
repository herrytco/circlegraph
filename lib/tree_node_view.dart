import 'package:circlegraph/point.dart';
import 'package:circlegraph/circle_tree.dart';
import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TreeNodeView extends StatefulWidget {
  final TreeNodeData data;
  final CircleTree containingTree;

  final double x;
  final double y;

  final Function(TreeNodeData) onHover;

  TreeNodeView(
      {@required this.data,
      @required this.x,
      @required this.y,
      @required this.containingTree,
      this.onHover}) {
    data.position = Point(x, y);
  }

  @override
  _TreeNodeViewState createState() => _TreeNodeViewState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      "NodeView(x:$x, y:$y)";
}

class _TreeNodeViewState extends State<TreeNodeView> {
  double _x;
  double _y;

  void _onTap() {
    widget.data.onClick();
  }

  void _onHover() {
    if (widget.onHover != null) widget.onHover(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    _x = widget.x - widget.data.width / 2;
    _y = widget.y - widget.data.height / 2;

    return Positioned(
      top: _y,
      left: _x,
      child: GestureDetector(
        onTap: _onTap,
        child: Listener(
          onPointerHover: (PointerHoverEvent event) => _onHover(),
          child: Container(
            alignment: Alignment.center,
            height: widget.data.height,
            width: widget.data.width,
            color: widget.data.color,
            child: widget.data.child,
          ),
        ),
      ),
    );
  }
}
