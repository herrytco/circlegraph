import 'package:flutter/material.dart';
import 'package:circlegraph/circle/tree_node_data.dart';

///
/// Represents a connection between two nodes in a CircleGraph
/// 
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
