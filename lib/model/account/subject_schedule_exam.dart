import 'dart:convert';

class SubjectScheduleExam {
  int date;
  String room;
  bool isGlobal;
  String group;

  SubjectScheduleExam.createDefault()
      : date = 0,
        room = '',
        isGlobal = false,
        group = '';

  SubjectScheduleExam({
    required this.date,
    required this.room,
    required this.isGlobal,
    required this.group,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'date': date});
    result.addAll({'room': room});
    result.addAll({'isGlobal': isGlobal});
    result.addAll({'group': group});

    return result;
  }

  factory SubjectScheduleExam.fromMap(Map<String, dynamic> map) {
    return SubjectScheduleExam(
      date: map['date']?.toInt() ?? 0,
      room: map['room'] ?? '',
      isGlobal: map['isGlobal'] ?? false,
      group: map['group'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectScheduleExam.fromJson(String source) =>
      SubjectScheduleExam.fromMap(json.decode(source));
}
