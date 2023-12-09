import 'dart:convert';

class TrainingSummary {
  final String schoolYearStart;
  final String schoolYearCurrent;
  final double creditCollected;
  final double avgTrainingScore4;
  final double avgSocial;

  TrainingSummary({
    required this.schoolYearStart,
    required this.schoolYearCurrent,
    required this.creditCollected,
    required this.avgTrainingScore4,
    required this.avgSocial,
  });

  TrainingSummary copyWith({
    String? schoolYearStart,
    String? schoolYearCurrent,
    double? creditCollected,
    double? avgTrainingScore4,
    double? avgSocial,
  }) {
    return TrainingSummary(
      schoolYearStart: schoolYearStart ?? this.schoolYearStart,
      schoolYearCurrent: schoolYearCurrent ?? this.schoolYearCurrent,
      creditCollected: creditCollected ?? this.creditCollected,
      avgTrainingScore4: avgTrainingScore4 ?? this.avgTrainingScore4,
      avgSocial: avgSocial ?? this.avgSocial,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'schoolYearStart': schoolYearStart});
    result.addAll({'schoolYearCurrent': schoolYearCurrent});
    result.addAll({'creditCollected': creditCollected});
    result.addAll({'avgTrainingScore4': avgTrainingScore4});
    result.addAll({'avgSocial': avgSocial});

    return result;
  }

  factory TrainingSummary.fromMap(Map<String, dynamic> map) {
    return TrainingSummary(
      schoolYearStart: map['schoolYearStart'] ?? '',
      schoolYearCurrent: map['schoolYearCurrent'] ?? '',
      creditCollected: map['creditCollected']?.toDouble() ?? 0.0,
      avgTrainingScore4: map['avgTrainingScore4']?.toDouble() ?? 0.0,
      avgSocial: map['avgSocial']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainingSummary.fromJson(String source) =>
      TrainingSummary.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TrainingSummary(schoolYearStart: $schoolYearStart, schoolYearCurrent: $schoolYearCurrent, creditCollected: $creditCollected, avgTrainingScore4: $avgTrainingScore4, avgSocial: $avgSocial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrainingSummary &&
        other.schoolYearStart == schoolYearStart &&
        other.schoolYearCurrent == schoolYearCurrent &&
        other.creditCollected == creditCollected &&
        other.avgTrainingScore4 == avgTrainingScore4 &&
        other.avgSocial == avgSocial;
  }

  @override
  int get hashCode {
    return schoolYearStart.hashCode ^
        schoolYearCurrent.hashCode ^
        creditCollected.hashCode ^
        avgTrainingScore4.hashCode ^
        avgSocial.hashCode;
  }
}
