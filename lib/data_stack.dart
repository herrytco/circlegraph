///
/// simple implementation of a Stack (https://en.wikipedia.org/wiki/Stack_(abstract_data_type))
/// stores elements of type [T]
///
class DataStack<T> {

  ///
  /// actual data in the stack 
  /// 
  final List<T> _data = [];

  ///
  /// insert one element at the top of the stack
  /// 
  void push(T element) => _data.insert(0, element);

  ///
  /// remove the first element on the stack and return it
  /// 
  T pop() {
    if (_data.length == 0) throw Exception("Stack was empty, cannot pop().");

    T result = _data.first;
    _data.removeAt(0);
    return result;
  }

  ///
  /// number of elements currently on the stack
  /// 
  int get length => _data.length;

  ///
  /// are there elements on the stack?
  /// 
  bool get isEmpty => _data.isEmpty;

  ///
  /// are there no elements on the stack? 
  /// 
  bool get isNotEmpty => _data.isNotEmpty;

  ///
  /// remove all elements from the stack and reset it
  /// 
  void clear() => _data.clear();

  ///
  /// accessor for the data to iterate over
  /// 
  List<T> get data => _data;
}
