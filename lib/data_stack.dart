class DataStack<T> {
  final List<T> _data = [];

  void push(T element) => _data.insert(0, element);

  T pop() {
    if (_data.length == 0) throw Exception("Stack was empty, cannot pop().");

    T result = _data.first;
    _data.removeAt(0);
    return result;
  }

  int get length => _data.length;

  bool get isEmpty => _data.isEmpty;
  bool get isNotEmpty => _data.isNotEmpty;

  void clear() => _data.clear();

  List<T> get data => _data;
}
