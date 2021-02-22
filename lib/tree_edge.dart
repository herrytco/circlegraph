import 'package:flutter/material.dart';
import 'package:circlegraph/tree_node_data.dart';

class TreeEdge {
  final TreeNodeData fromNode;
  final TreeNodeData toNode;

  final double strokeWidth;
  final Color edgeColor;
  final bool isDashedLine;

  TreeEdge(
      {@required this.fromNode,
      @required this.toNode,
      this.strokeWidth = 1,
      this.edgeColor = Colors.black,
      this.isDashedLine = false});
}
