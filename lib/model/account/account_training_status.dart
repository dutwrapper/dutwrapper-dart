import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'graduate_status.dart';
import 'subject_result.dart';
import 'training_summary.dart';

class AccountTrainingStatus {
  final TrainingSummary trainingSummary;
  final GraduateStatus graduateStatus;
  final List<SubjectResult> subjectResultList;

  AccountTrainingStatus({
    required this.trainingSummary,
    required this.graduateStatus,
    required this.subjectResultList,
  });

  AccountTrainingStatus copyWith({
    TrainingSummary? trainingSummary,
    GraduateStatus? graduateStatus,
    List<SubjectResult>? subjectResultList,
  }) {
    return AccountTrainingStatus(
      trainingSummary: trainingSummary ?? this.trainingSummary,
      graduateStatus: graduateStatus ?? this.graduateStatus,
      subjectResultList: subjectResultList ?? this.subjectResultList,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'trainingSummary': trainingSummary.toMap()});
    result.addAll({'graduateStatus': graduateStatus.toMap()});
    result.addAll({
      'subjectResultList': subjectResultList.map((x) => x.toMap()).toList()
    });

    return result;
  }

  factory AccountTrainingStatus.fromMap(Map<String, dynamic> map) {
    return AccountTrainingStatus(
      trainingSummary: TrainingSummary.fromMap(map['trainingSummary']),
      graduateStatus: GraduateStatus.fromMap(map['graduateStatus']),
      subjectResultList: List<SubjectResult>.from(
          map['subjectResultList']?.map((x) => SubjectResult.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountTrainingStatus.fromJson(String source) =>
      AccountTrainingStatus.fromMap(json.decode(source));

  @override
  String toString() =>
      'AccountTrainingStatus(trainingSummary: $trainingSummary, graduateStatus: $graduateStatus, subjectResultList: $subjectResultList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountTrainingStatus &&
        other.trainingSummary == trainingSummary &&
        other.graduateStatus == graduateStatus &&
        listEquals(other.subjectResultList, subjectResultList);
  }

  @override
  int get hashCode =>
      trainingSummary.hashCode ^
      graduateStatus.hashCode ^
      subjectResultList.hashCode;
}
