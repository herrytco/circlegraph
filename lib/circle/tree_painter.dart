import 'package:circlegraph/circlegraph.dart';
import 'package:circlegraph/circle/tree_edge.dart';
import 'package:circlegraph/circle/tree_node_data.dart';
import 'package:flutter/material.dart';

///
/// Paints the edges between nodes in the CircleGraph
///
class TreePainter extends CustomPainter {
  ///
  /// tree, which contains drawing-information (nodes, edges, ...)
  ///
  final CircleGraph tree;

  TreePainter({this.tree});

  @override
  void paint(Canvas canvas, Size size) {
    List<TreeNodeData> nodesToPaint = [tree.root];

    while (nodesToPaint.isNotEmpty) {
      TreeNodeData nodeToPaint = nodesToPaint.first;
      nodesToPaint.removeAt(0);

      _paintNode(canvas, nodeToPaint);
    }
  }

  ///
  /// Paint a single node and all connected nodes with the visual settings in
  /// the node edges.
  ///
  void _paintNode(Canvas canvas, TreeNodeData node) {
    for (TreeEdge edge in node.connectedNodes) {
      // draw line from node to connectedNode
      TreeNodeData connectedNode = edge.toNode;

      Offset pNode = Offset(node.position.x, node.position.y);
      Offset pConnectedNode =
          Offset(connectedNode.position.x, connectedNode.position.y);

      Paint paint = Paint()
        ..color = edge.edgeColor
        ..strokeWidth = edge.strokeWidth;

      canvas.drawLine(pNode, pConnectedNode, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
