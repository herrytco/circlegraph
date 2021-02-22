import 'package:circlegraph/tree.dart';
import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/material.dart';

class TreePainter extends CustomPainter {
  final CircleTree tree;
  final double strokeWidth;

  TreePainter({this.tree, this.strokeWidth = 1});

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
    for (TreeNodeData connectedNode in node.connectedNodes) {
      // draw line from node to connectedNode

      Offset pNode = Offset(node.realization.x, node.realization.y);
      Offset pConnectedNode =
          Offset(connectedNode.realization.x, connectedNode.realization.y);

      Paint paint = Paint()
        ..color = Colors.black
        ..strokeWidth = strokeWidth;

      canvas.drawLine(pNode, pConnectedNode, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
