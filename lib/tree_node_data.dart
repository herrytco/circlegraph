import 'package:circlegraph/tree_node_view.dart';
import 'package:flutter/material.dart';

class TreeNodeData {
  final double height;
  final double width;
  final Widget child;

  final Color color;

  final List<TreeNodeData> connectedNodes = [];

  TreeNodeView _realization;

  TreeNodeView get realization {
    if (_realization == null)
      throw Exception(
          "Node was not realized yet! Access this property after passing the node to a CircleTree");

    return _realization;
  }

  set realization(TreeNodeView view) {
    _realization = view;
  }

  TreeNodeData({
    this.height = 50,
    this.width = 100,
    this.color = Colors.blue,
    @required this.child,
  });

  void addEdgeTo(TreeNodeData toNode) {
    connectedNodes.add(toNode);
  }
}
