import 'dart:convert';

import '../range_class.dart';

class SubjectScheduleStudy {
  // 0: Sunday, 1: Monday -> 6: Saturday
  int dayOfWeek = 0;
  RangeInt lesson = RangeInt(start: 0, end: 0);
  String room = '';

  SubjectScheduleStudy();

  SubjectScheduleStudy.from({
    required this.dayOfWeek,
    required this.lesson,
    required this.room,
  });

  SubjectScheduleStudy copyWith({
    int? dayOfWeek,
    RangeInt? lesson,
    String? room,
  }) {
    return SubjectScheduleStudy.from(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      lesson: lesson ?? this.lesson,
      room: room ?? this.room,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'dayOfWeek': dayOfWeek});
    result.addAll({'lesson': lesson});
    result.addAll({'room': room});

    return result;
  }

  factory SubjectScheduleStudy.fromMap(Map<String, dynamic> map) {
    return SubjectScheduleStudy.from(
      dayOfWeek: map['dayOfWeek']?.toInt() ?? 0,
      lesson: map['lesson'] ?? RangeInt(start: 0, end: 0),
      room: map['room'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectScheduleStudy.fromJson(String source) =>
      SubjectScheduleStudy.fromMap(json.decode(source));

  @override
  String toString() =>
      'SubjectScheduleStudy(dayOfWeek: $dayOfWeek, lesson: $lesson, room: $room)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectScheduleStudy &&
        other.dayOfWeek == dayOfWeek &&
        other.lesson == lesson &&
        other.room == room;
  }

  @override
  int get hashCode => dayOfWeek.hashCode ^ lesson.hashCode ^ room.hashCode;
}

class SubjectScheduleStudyList {
  List<SubjectScheduleStudy> subjectStudyList = [];
  List<RangeInt> weekList = [];
}
