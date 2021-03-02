import 'dart:math';

class Tuple {
  double x;
  double y;

  Tuple(this.x, this.y);

  double get largestElement => max(x, y);

  double get magnitude => sqrt(pow(x, 2) + pow(y, 2));

  void addTo(double xOther, double yOther) {
    x += xOther;
    y += yOther;
  }

  void addVectorTo(Tuple other) {
    x += other.x;
    y += other.y;
  }

  void addScalarTo(double scalar) {
    x += scalar;
    y += scalar;
  }

  @override
  String toString() {
    return "Tuple($x/$y)";
  }
}
