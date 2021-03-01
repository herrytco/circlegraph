import 'dart:math';

class Tuple {
  final double x;
  final double y;

  Tuple(this.x, this.y);

  double get largestElement => max(x, y);

  double get magnitude => sqrt(pow(x, 2) + pow(y, 2));

  @override
  String toString() {
    return "Tuple($x/$y)";
  }
}
