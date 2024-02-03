import 'dart:convert';

class GraduateStatus {
  final bool hasSigGDTC;
  final bool hasSigGDQP;
  final bool hasSigEnglish;
  final bool hasSigIT;
  final bool hasQualifiedGraduate;
  final String info1;
  final String info2;
  final String info3;
  final String approveGraduateProcessInfo;

  GraduateStatus({
    required this.hasSigGDTC,
    required this.hasSigGDQP,
    required this.hasSigEnglish,
    required this.hasSigIT,
    required this.hasQualifiedGraduate,
    required this.info1,
    required this.info2,
    required this.info3,
    required this.approveGraduateProcessInfo,
  });

  GraduateStatus copyWith({
    bool? hasSigGDTC,
    bool? hasSigGDQP,
    bool? hasSigEnglish,
    bool? hasSigIT,
    bool? hasQualifiedGraduate,
    String? info1,
    String? info2,
    String? info3,
    String? approveGraduateProcessInfo,
  }) {
    return GraduateStatus(
      hasSigGDTC: hasSigGDTC ?? this.hasSigGDTC,
      hasSigGDQP: hasSigGDQP ?? this.hasSigGDQP,
      hasSigEnglish: hasSigEnglish ?? this.hasSigEnglish,
      hasSigIT: hasSigIT ?? this.hasSigIT,
      hasQualifiedGraduate: hasQualifiedGraduate ?? this.hasQualifiedGraduate,
      info1: info1 ?? this.info1,
      info2: info2 ?? this.info2,
      info3: info3 ?? this.info3,
      approveGraduateProcessInfo:
          approveGraduateProcessInfo ?? this.approveGraduateProcessInfo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'hasSigGDTC': hasSigGDTC});
    result.addAll({'hasSigGDQP': hasSigGDQP});
    result.addAll({'hasSigEnglish': hasSigEnglish});
    result.addAll({'hasSigIT': hasSigIT});
    result.addAll({'hasQualifiedGraduate': hasQualifiedGraduate});
    result.addAll({'info1': info1});
    result.addAll({'info2': info2});
    result.addAll({'info3': info3});
    result.addAll({'approveGraduateProcessInfo': approveGraduateProcessInfo});

    return result;
  }

  factory GraduateStatus.fromMap(Map<String, dynamic> map) {
    return GraduateStatus(
      hasSigGDTC: map['hasSigGDTC'] ?? false,
      hasSigGDQP: map['hasSigGDQP'] ?? false,
      hasSigEnglish: map['hasSigEnglish'] ?? false,
      hasSigIT: map['hasSigIT'] ?? false,
      hasQualifiedGraduate: map['hasQualifiedGraduate'] ?? false,
      info1: map['info1'] ?? '',
      info2: map['info2'] ?? '',
      info3: map['info3'] ?? '',
      approveGraduateProcessInfo: map['approveGraduateProcessInfo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GraduateStatus.fromJson(String source) =>
      GraduateStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GraduateStatus(hasSigGDTC: $hasSigGDTC, hasSigGDQP: $hasSigGDQP, hasSigEnglish: $hasSigEnglish, hasSigIT: $hasSigIT, hasQualifiedGraduate: $hasQualifiedGraduate, info1: $info1, info2: $info2, info3: $info3, approveGraduateProcessInfo: $approveGraduateProcessInfo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraduateStatus &&
        other.hasSigGDTC == hasSigGDTC &&
        other.hasSigGDQP == hasSigGDQP &&
        other.hasSigEnglish == hasSigEnglish &&
        other.hasSigIT == hasSigIT &&
        other.hasQualifiedGraduate == hasQualifiedGraduate &&
        other.info1 == info1 &&
        other.info2 == info2 &&
        other.info3 == info3 &&
        other.approveGraduateProcessInfo == approveGraduateProcessInfo;
  }

  @override
  int get hashCode {
    return hasSigGDTC.hashCode ^
        hasSigGDQP.hashCode ^
        hasSigEnglish.hashCode ^
        hasSigIT.hashCode ^
        hasQualifiedGraduate.hashCode ^
        info1.hashCode ^
        info2.hashCode ^
        info3.hashCode ^
        approveGraduateProcessInfo.hashCode;
  }
}
