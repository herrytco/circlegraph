import 'package:circlegraph/tuple.dart';
import 'package:circlegraph/circle/tree_edge.dart';
import 'package:flutter/material.dart';

///
/// Represents the raw data of a node in a CircleGraph
/// 
class TreeNodeData<T> {
  ///
  /// height of the node
  /// 
  final double height;

  ///
  /// width of the node
  ///
  final double width;

  ///
  /// widget to be displayed in the node
  /// 
  final Widget child;

  ///
  /// background color of the node
  /// 
  final Color backgroundColor;

  ///
  /// other nodes connected to this one
  /// 
  final List<TreeEdge> connectedNodes = [];

  ///
  /// data stored in the node. it is not displayed per default but can be used
  /// in onClick callbacks.
  /// 
  final T data;

  ///
  /// called when the node is clicked on. 
  /// 
  final Function(TreeNodeData, T) onNodeClick;

  ///
  /// position of the node in the graph
  /// 
  Tuple position;

  ///
  /// called when a click/tap on the node was registered. calls [onNodeClick] if
  /// it is not null
  /// 
  void onClick() {
    if (onNodeClick != null) onNodeClick(this, data);
  }

  ///
  /// Add an outgoing edge from this node to toNode with the given visual settings.
  ///
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

  ///
  /// Clears all outgoing edges from this node.
  ///
  void clearEdges() => connectedNodes.clear();

  TreeNodeData({
    this.height = 50,
    this.width = 100,
    this.backgroundColor = Colors.blue,
    this.onNodeClick,
    @required this.child,
    @required this.data,
  });

  @override
  String toString() {
    return "Node($data)";
  }
}
