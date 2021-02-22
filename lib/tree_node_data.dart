import 'package:circlegraph/tree_edge.dart';
import 'package:circlegraph/tree_node_view.dart';
import 'package:flutter/material.dart';

class TreeNodeData<T> {
  final double height;
  final double width;
  final Widget child;

  final Color color;

  final List<TreeEdge> connectedNodes = [];
  final T data;

  final Function(TreeNodeData, T) onNodeClick;

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

  void onClick() {
    if (onNodeClick != null) onNodeClick(this, data);
  }

  TreeNodeData({
    this.height = 50,
    this.width = 100,
    this.color = Colors.blue,
    this.onNodeClick,
    @required this.child,
    @required this.data,
  });

  void addEdgeTo(
    TreeNodeData toNode, {
    double strokeWidth = 1,
    Color edgeColor = Colors.black,
    bool isDashedLine = false,
  }) {
    connectedNodes.add(
      TreeEdge(
        fromNode: this,
        toNode: toNode,
        strokeWidth: strokeWidth,
        edgeColor: edgeColor,
        isDashedLine: isDashedLine,
      ),
    );
  }
}
