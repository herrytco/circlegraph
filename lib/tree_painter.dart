import 'package:circlegraph/tree.dart';
import 'package:circlegraph/tree_edge.dart';
import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/material.dart';

class TreePainter extends CustomPainter {
  final CircleTree tree;

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

  void _paintNode(Canvas canvas, TreeNodeData node) {
    for (TreeEdge edge in node.connectedNodes) {
      // draw line from node to connectedNode
      TreeNodeData connectedNode = edge.toNode;

      Offset pNode = Offset(node.realization.x, node.realization.y);
      Offset pConnectedNode =
          Offset(connectedNode.realization.x, connectedNode.realization.y);

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
