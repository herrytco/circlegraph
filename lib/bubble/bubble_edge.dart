import 'package:circlegraph/bubble/circle_tree_view.dart';

///
/// stores two neighbouring realized circles (with position data)
/// 
class BubbleEdge {
  CircleTreeView c1;
  CircleTreeView c2;

  BubbleEdge(this.c1, this.c2);

  ///
  /// replaces eigher [c1] or [c2] with [view] depending on 
  /// which one has the same [view.tree]
  /// 
  void replaceCircleTreeView(CircleTreeView view) {
    if (view.tree == c1.tree)
      c1 = view;
    else if (view.tree == c2.tree) c2 = view;
  }
}
