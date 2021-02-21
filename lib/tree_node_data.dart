import 'package:flutter/material.dart';

class TreeNodeData {
  final double height;
  final double width;
  final Widget child;

  final Color color;

  TreeNodeData({
    this.height = 50,
    this.width = 100,
    this.color = Colors.blue,
    @required this.child,
  });
}
