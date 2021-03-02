import 'package:circlegraph/bubble/circle_tree_view.dart';

class BubbleEdge {
  CircleTreeView c1;
  CircleTreeView c2;

  BubbleEdge(this.c1, this.c2);

  void replaceCircleTreeView(CircleTreeView tree) {
    if (tree.tree == c1.tree)
      c1 = tree;
    else if (tree.tree == c2.tree) c2 = tree;
  }
}
