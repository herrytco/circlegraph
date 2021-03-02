import 'package:circlegraph/tuple.dart';
import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/circle/tree_node_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///
/// Realized node in a CircleGraph (holds a position)
/// 
class TreeNodeView extends StatefulWidget {

  ///
  /// node data
  /// 
  final TreeNodeData data;

  ///
  /// tree the node is drawn in. used to deliver callbacks
  /// 
  final CircleTree containingTree;

  ///
  /// space between the left edge of the node and the border of the containing
  /// box without padding
  /// 
  final double x;

  ///
  /// space between the top edge of the node and the border of the containing
  /// box without padding
  /// 
  final double y;

  ///
  /// callback, fired when the cursor hovers over the node
  /// 
  final Function(TreeNodeData) onHover;

  TreeNodeView(
      {@required this.data,
      @required this.x,
      @required this.y,
      @required this.containingTree,
      this.onHover}) {
    data.position = Tuple(x, y);
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
            color: widget.data.backgroundColor,
            child: widget.data.child,
          ),
        ),
      ),
    );
  }
}
