import 'dart:convert';

class SubjectResult {
  final int index;
  final String schoolYear;
  final bool isExtendedSemester;
  final String id;
  final String name;
  final double credit;
  final String? pointFormula;
  final double? pointBT;
  final double? pointBV;
  final double? pointCC;
  final double? pointCK;
  final double? pointGK;
  final double? pointQT;
  final double? pointTH;
  final double? resultT4;
  final double? resultT10;
  final String? resultByCharacter;
  final bool isReStudy;

  SubjectResult({
    required this.index,
    required this.schoolYear,
    required this.isExtendedSemester,
    required this.id,
    required this.name,
    required this.credit,
    this.pointFormula,
    this.pointBT,
    this.pointBV,
    this.pointCC,
    this.pointCK,
    this.pointGK,
    this.pointQT,
    this.pointTH,
    this.resultT4,
    this.resultT10,
    this.resultByCharacter,
    required this.isReStudy,
  });

  SubjectResult copyWith({
    int? index,
    String? schoolYear,
    bool? isExtendedSemester,
    String? id,
    String? name,
    double? credit,
    String? pointFormula,
    double? pointBT,
    double? pointBV,
    double? pointCC,
    double? pointCK,
    double? pointGK,
    double? pointQT,
    double? pointTH,
    double? resultT4,
    double? resultT10,
    String? resultByCharacter,
    bool? isReStudy,
  }) {
    return SubjectResult(
      index: index ?? this.index,
      schoolYear: schoolYear ?? this.schoolYear,
      isExtendedSemester: isExtendedSemester ?? this.isExtendedSemester,
      id: id ?? this.id,
      name: name ?? this.name,
      credit: credit ?? this.credit,
      pointFormula: pointFormula ?? this.pointFormula,
      pointBT: pointBT ?? this.pointBT,
      pointBV: pointBV ?? this.pointBV,
      pointCC: pointCC ?? this.pointCC,
      pointCK: pointCK ?? this.pointCK,
      pointGK: pointGK ?? this.pointGK,
      pointQT: pointQT ?? this.pointQT,
      pointTH: pointTH ?? this.pointTH,
      resultT4: resultT4 ?? this.resultT4,
      resultT10: resultT10 ?? this.resultT10,
      resultByCharacter: resultByCharacter ?? this.resultByCharacter,
      isReStudy: isReStudy ?? this.isReStudy,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'index': index});
    result.addAll({'schoolYear': schoolYear});
    result.addAll({'isExtendedSemester': isExtendedSemester});
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'credit': credit});
    if (pointFormula != null) {
      result.addAll({'pointFormula': pointFormula});
    }
    if (pointBT != null) {
      result.addAll({'pointBT': pointBT});
    }
    if (pointBV != null) {
      result.addAll({'pointBV': pointBV});
    }
    if (pointCC != null) {
      result.addAll({'pointCC': pointCC});
    }
    if (pointCK != null) {
      result.addAll({'pointCK': pointCK});
    }
    if (pointGK != null) {
      result.addAll({'pointGK': pointGK});
    }
    if (pointQT != null) {
      result.addAll({'pointQT': pointQT});
    }
    if (pointTH != null) {
      result.addAll({'pointTH': pointTH});
    }
    if (resultT4 != null) {
      result.addAll({'resultT4': resultT4});
    }
    if (resultT10 != null) {
      result.addAll({'resultT10': resultT10});
    }
    if (resultByCharacter != null) {
      result.addAll({'resultByCharacter': resultByCharacter});
    }
    result.addAll({'isReStudy': isReStudy});

    return result;
  }

  factory SubjectResult.fromMap(Map<String, dynamic> map) {
    return SubjectResult(
      index: map['index']?.toInt() ?? 0,
      schoolYear: map['schoolYear'] ?? '',
      isExtendedSemester: map['isExtendedSemester'] ?? false,
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      credit: map['credit']?.toDouble() ?? 0.0,
      pointFormula: map['pointFormula'],
      pointBT: map['pointBT']?.toDouble(),
      pointBV: map['pointBV']?.toDouble(),
      pointCC: map['pointCC']?.toDouble(),
      pointCK: map['pointCK']?.toDouble(),
      pointGK: map['pointGK']?.toDouble(),
      pointQT: map['pointQT']?.toDouble(),
      pointTH: map['pointTH']?.toDouble(),
      resultT4: map['resultT4']?.toDouble(),
      resultT10: map['resultT10']?.toDouble(),
      resultByCharacter: map['resultByCharacter'],
      isReStudy: map['isReStudy'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectResult.fromJson(String source) =>
      SubjectResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectResult(index: $index, schoolYear: $schoolYear, isExtendedSemester: $isExtendedSemester, id: $id, name: $name, credit: $credit, pointFormula: $pointFormula, pointBT: $pointBT, pointBV: $pointBV, pointCC: $pointCC, pointCK: $pointCK, pointGK: $pointGK, pointQT: $pointQT, pointTH: $pointTH, resultT4: $resultT4, resultT10: $resultT10, resultByCharacter: $resultByCharacter, isReStudy: $isReStudy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectResult &&
        other.index == index &&
        other.schoolYear == schoolYear &&
        other.isExtendedSemester == isExtendedSemester &&
        other.id == id &&
        other.name == name &&
        other.credit == credit &&
        other.pointFormula == pointFormula &&
        other.pointBT == pointBT &&
        other.pointBV == pointBV &&
        other.pointCC == pointCC &&
        other.pointCK == pointCK &&
        other.pointGK == pointGK &&
        other.pointQT == pointQT &&
        other.pointTH == pointTH &&
        other.resultT4 == resultT4 &&
        other.resultT10 == resultT10 &&
        other.resultByCharacter == resultByCharacter &&
        other.isReStudy == isReStudy;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        schoolYear.hashCode ^
        isExtendedSemester.hashCode ^
        id.hashCode ^
        name.hashCode ^
        credit.hashCode ^
        pointFormula.hashCode ^
        pointBT.hashCode ^
        pointBV.hashCode ^
        pointCC.hashCode ^
        pointCK.hashCode ^
        pointGK.hashCode ^
        pointQT.hashCode ^
        pointTH.hashCode ^
        resultT4.hashCode ^
        resultT10.hashCode ^
        resultByCharacter.hashCode ^
        isReStudy.hashCode;
  }
}
