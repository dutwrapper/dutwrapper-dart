class CustomClock {
  final int hour, minute;

  CustomClock({
    required this.hour,
    required this.minute,
  });

  CustomClock.current()
      : hour = DateTime.now().hour,
        minute = DateTime.now().minute;

  @override
  bool operator ==(other) {
    return other is CustomClock && hour == other.hour && minute == other.minute;
  }

  bool operator >(other) {
    return other is CustomClock &&
        (hour > other.hour || (hour == other.hour && minute > other.minute));
  }

  bool operator <(other) {
    return other is CustomClock &&
        (hour < other.hour || (hour == other.hour && minute < other.minute));
  }

  @override
  int get hashCode => hour * 60 + minute;

  @override
  String toString() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  bool isInRange(CustomClock valLeft, CustomClock valRight) {
    return (valLeft < valRight)
        ? (valLeft < this && this < valRight)
        : (valLeft > valRight)
            ? ((valRight < this && valLeft < this) ||
                (valRight > this && valLeft > this))
            : (valLeft == this && this == valRight);
  }

  int toDUTLesson() {
    var data = [
      CustomClock(hour: 7, minute: 0),
      CustomClock(hour: 8, minute: 0),
      CustomClock(hour: 9, minute: 0),
      CustomClock(hour: 10, minute: 0),
      CustomClock(hour: 11, minute: 0),
      CustomClock(hour: 12, minute: 0),
      CustomClock(hour: 12, minute: 30),
      CustomClock(hour: 13, minute: 30),
      CustomClock(hour: 14, minute: 30),
      CustomClock(hour: 15, minute: 30),
      CustomClock(hour: 16, minute: 30),
      CustomClock(hour: 17, minute: 30),
      CustomClock(hour: 18, minute: 15),
      CustomClock(hour: 19, minute: 10),
      CustomClock(hour: 19, minute: 55),
      CustomClock(hour: 20, minute: 30),
    ];
    var data2 = [-2, 1, 2, 3, 4, 5, -1, 6, 7, 8, 9, 10, 11, 12, 13, 14];

    for (var item in data) {
      if (this < item) {
        return data2[data.indexOf(item)];
      }
    }

    return 0;
  }
}
