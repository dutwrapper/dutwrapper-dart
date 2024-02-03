import 'dart:convert';

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
    super.start = 0,
    super.end = 0,
  });

  @override
  bool isBetween(int input) {
    return start <= input && input <= end;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'start': start});
    result.addAll({'end': end});

    return result;
  }

  factory RangeInt.fromMap(Map<String, dynamic> map) {
    return RangeInt(
      start: map['start'],
      end: map['end'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RangeInt.fromJson(String source) =>
      RangeInt.fromMap(json.decode(source));
}
