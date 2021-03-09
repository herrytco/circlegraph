///
/// describes one layer of the circle chart
/// 
class Circle {
  final double radius;
  final double nElements;

  Circle(this.radius, this.nElements);

  @override
  String toString() {
    return "Circle($radius, $nElements)";
  }
}
