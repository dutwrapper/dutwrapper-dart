import 'dart:convert';

class DutSchoolYear {
  int week;
  String schoolYear;
  int schoolYearVal;

  DutSchoolYear({
    required this.schoolYear,
    required this.schoolYearVal,
    required this.week,
  });

  @override
  String toString() {
    return "School year: $schoolYear\nSchool year value: $schoolYearVal\nWeek $week";
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'week': week});
    result.addAll({'schoolYear': schoolYear});
    result.addAll({'schoolYearVal': schoolYearVal});

    return result;
  }

  factory DutSchoolYear.fromMap(Map<String, dynamic> map) {
    return DutSchoolYear(
      week: map['week']?.toInt() ?? 0,
      schoolYear: map['schoolYear'] ?? '',
      schoolYearVal: map['schoolYearVal']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DutSchoolYear.fromJson(String source) =>
      DutSchoolYear.fromMap(json.decode(source));
}
