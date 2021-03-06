import 'package:circlegraph/circle/tree_node_data.dart';
import 'package:flutter/material.dart';

enum DrawMode { TOPRIGHT, TOPLEFT, BOTTOMRIGHT, BOTTOMLEFT }

///
/// Tooltip appearing when the mouse hovers over a node
///
class GraphTooltip<T> extends StatelessWidget {
  ///
  /// The node the mouse currently hovers over can be retrieved via this
  /// function
  ///
  final TreeNodeData Function() parent;

  ///
  /// Widget to draw the node
  ///
  final Widget tooltip;

  ///
  ///  width of the box the graph is drawn without padding.
  ///
  final double treeBoxWidth;

  ///
  /// height of the box the graph is drawn without padding.
  ///
  final double treeBoxHeight;

  GraphTooltip(
      this.parent, this.tooltip, this.treeBoxHeight, this.treeBoxWidth);

  ///
  /// Compare the draw position to the size of the container containing the
  /// graph and determine in which quadrant the node is located. This will
  /// control in which orientation the tooltip will be drawn later.
  ///
  DrawMode determineDrawmode(TreeNodeData node) {
    if (node.position.x <= treeBoxWidth / 2 &&
        node.position.y <= treeBoxHeight / 2) return DrawMode.TOPLEFT;
    if (node.position.x > treeBoxWidth / 2 &&
        node.position.y <= treeBoxHeight / 2) return DrawMode.TOPRIGHT;
    if (node.position.x <= treeBoxWidth / 2 &&
        node.position.y > treeBoxHeight / 2) return DrawMode.BOTTOMLEFT;
    if (node.position.x > treeBoxWidth / 2 &&
        node.position.y > treeBoxHeight / 2) return DrawMode.BOTTOMRIGHT;

    throw Exception("Something impossible just happened...");
  }

  @override
  Widget build(BuildContext context) {
    TreeNodeData hostingNode = parent();

    if (hostingNode != null) {
      DrawMode mode = determineDrawmode(hostingNode);

      switch (mode) {
        case DrawMode.TOPLEFT:
          return Positioned(
            top: hostingNode.position.y,
            left: hostingNode.position.x,
            child: tooltip,
          );
        case DrawMode.TOPRIGHT:
          return Positioned(
            top: hostingNode.position.y,
            right: treeBoxWidth - hostingNode.position.x,
            child: tooltip,
          );
        case DrawMode.BOTTOMLEFT:
          return Positioned(
            bottom: treeBoxHeight - hostingNode.position.y,
            left: hostingNode.position.x,
            child: tooltip,
          );
        case DrawMode.BOTTOMRIGHT:
          return Positioned(
            bottom: treeBoxHeight - hostingNode.position.y,
            right: treeBoxWidth - hostingNode.position.x,
            child: tooltip,
          );
        default:
          throw Exception("enum was not covered fully...");
      }
    }

    return SizedBox();
  }
}
