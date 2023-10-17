abstract class Range<T> {
  final T start;
  final T end;

  const Range({
    required this.start,
    required this.end,
  });

  @override
  String toString({String prefix = '-'}) {
    return '$start$prefix$end';
  }

  bool isBetween(T input);
}

class RangeInt extends Range<int> {
  RangeInt({
    required super.start,
    required super.end,
  });

  @override
  bool isBetween(int input) {
    return start <= input && input <= end;
  }
}
