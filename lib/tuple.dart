import 'dart:math';

class Tuple {
  final double x;
  final double y;

  Tuple(this.x, this.y);

  double get largestElement {
    return max(x, y);
  }

  @override
  String toString() {
    return "Tuple($x/$y)";
  }
}
