import 'package:circlegraph/tree_node_data.dart';
import 'package:flutter/material.dart';

enum DrawMode { TOPRIGHT, TOPLEFT, BOTTOMRIGHT, BOTTOMLEFT }

class GraphTooltip<T> extends StatelessWidget {
  final TreeNodeData Function() parent;
  final Widget tooltip;
  final double treeBoxWidth;
  final double treeBoxHeight;

  GraphTooltip(
      this.parent, this.tooltip, this.treeBoxHeight, this.treeBoxWidth);

  DrawMode determineDrawmode(TreeNodeData node) {
    if (node.position.x < treeBoxWidth / 2 &&
        node.position.y < treeBoxHeight / 2) return DrawMode.TOPLEFT;
    if (node.position.x >= treeBoxWidth / 2 &&
        node.position.y < treeBoxHeight / 2) return DrawMode.TOPRIGHT;
    if (node.position.x < treeBoxWidth / 2 &&
        node.position.y >= treeBoxHeight / 2) return DrawMode.BOTTOMLEFT;
    if (node.position.x >= treeBoxWidth / 2 &&
        node.position.y >= treeBoxHeight / 2) return DrawMode.BOTTOMRIGHT;

    throw Exception("Something impossible just happened...");
  }

  Positioned positionedForTooltip(TreeNodeData node, Widget child) {
    DrawMode mode = determineDrawmode(node);

    switch (mode) {
      case DrawMode.TOPLEFT:
        return Positioned(
          top: node.position.y,
          left: node.position.x,
          child: child,
        );
      case DrawMode.TOPRIGHT:
        return Positioned(
          top: node.position.y,
          right: treeBoxWidth - node.position.x + node.width / 2,
          child: child,
        );
      case DrawMode.BOTTOMLEFT:
        return Positioned(
          bottom: treeBoxHeight - node.position.y - node.height,
          left: node.position.x,
          child: child,
        );
      case DrawMode.BOTTOMRIGHT:
        return Positioned(
          bottom: treeBoxHeight - node.position.y - node.height,
          right: treeBoxWidth - node.position.x + node.width / 2,
          child: child,
        );
      default:
        throw Exception("enum was not covered fully...");
    }
  }

  @override
  Widget build(BuildContext context) {
    TreeNodeData hostingNode = parent();

    return hostingNode != null
        ? positionedForTooltip(
            hostingNode,
            tooltip,
          )
        : SizedBox();
  }
}
