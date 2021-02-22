import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/material.dart';

class TreeNodeView extends StatefulWidget {
  final TreeNodeData data;

  final double x;
  final double y;

  TreeNodeView({
    @required this.data,
    @required this.x,
    @required this.y,
  });

  @override
  _TreeNodeViewState createState() => _TreeNodeViewState();
}

class _TreeNodeViewState extends State<TreeNodeView> {
  double _x;
  double _y;

  @override
  void initState() {
    super.initState();
    _x = widget.x - widget.data.width / 2;
    _y = widget.y - widget.data.height / 2;
  }

  void _onTap() {
    widget.data.onClick();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _y,
      left: _x,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          alignment: Alignment.center,
          height: widget.data.height,
          width: widget.data.width,
          color: widget.data.color,
          child: widget.data.child,
        ),
      ),
    );
  }
}
