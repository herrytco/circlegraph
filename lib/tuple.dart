import 'dart:math';

///
/// holds two numbers and provides simple operations on them 
class Tuple {

  ///
  /// coordinate 1
  /// 
  double x;

  ///
  /// coordinate 2
  /// 
  double y;

  Tuple(this.x, this.y);

  ///
  /// get the bigger element of the 2
  /// 
  double get largestElement => max(x, y);

  ///
  /// get the length of the vector 
  /// 
  double get magnitude => sqrt(pow(x, 2) + pow(y, 2));

  ///
  /// add two scalars to the vector [xOther] to [x] and [yOther] to [y]
  /// 
  void addTo(double xOther, double yOther) {
    x += xOther;
    y += yOther;
  }

  ///
  /// add a vector to this one
  /// 
  void addVectorTo(Tuple other) {
    x += other.x;
    y += other.y;
  }

  ///
  /// add one scalar to BOTH coordinates
  /// 
  void addScalarTo(double scalar) {
    x += scalar;
    y += scalar;
  }

  @override
  String toString() {
    return "Tuple($x/$y)";
  }
}
