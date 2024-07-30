import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'range_class.dart';
import 'subject_code.dart';

class SubjectInformation {
  SubjectCode id;
  String name;
  int credit;
  bool isHighQuality;
  String lecturerName;
  ScheduleStudy subjectStudy;
  ScheduleExam subjectExam;
  String pointFormula;

  SubjectInformation.createDefault()
      : id = SubjectCode(),
        name = '',
        credit = 0,
        isHighQuality = false,
        lecturerName = '',
        subjectStudy = ScheduleStudy.createDefault(),
        subjectExam = ScheduleExam.createDefault(),
        pointFormula = '';

  SubjectInformation({
    required this.id,
    required this.name,
    required this.credit,
    required this.isHighQuality,
    required this.lecturerName,
    required this.subjectStudy,
    required this.subjectExam,
    required this.pointFormula,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id.toMap()});
    result.addAll({'name': name});
    result.addAll({'credit': credit});
    result.addAll({'is_high_quality': isHighQuality});
    result.addAll({'lecturer': lecturerName});
    result.addAll({'schedule_study': subjectStudy.toMap()});
    result.addAll({'schedule_exam': subjectExam.toMap()});
    result.addAll({'point_formula': pointFormula});

    return result;
  }

  factory SubjectInformation.fromMap(Map<String, dynamic> map) {
    return SubjectInformation(
      id: SubjectCode.fromMap(map['id']),
      name: map['name'] ?? '',
      credit: map['credit']?.toInt() ?? 0,
      isHighQuality: map['is_high_quality'] ?? false,
      lecturerName: map['lecturer'] ?? '',
      subjectStudy: map['schedule_study'] != null
          ? ScheduleStudy.fromMap(map['schedule_study'])
          : ScheduleStudy.createDefault(),
      subjectExam: map['schedule_exam'] != null
          ? ScheduleExam.fromMap(map['schedule_exam'])
          : ScheduleExam.createDefault(),
      pointFormula: map['point_formula'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectInformation.fromJson(String source) =>
      SubjectInformation.fromMap(json.decode(source));
}

class SubjectSchedule {
  // 0: Sunday, 1: Monday -> 6: Saturday
  int dayOfWeek = 0;
  RangeInt lesson = RangeInt(start: 0, end: 0);
  String room = '';

  SubjectSchedule();

  SubjectSchedule.from({
    required this.dayOfWeek,
    required this.lesson,
    required this.room,
  });

  SubjectSchedule copyWith({
    int? dayOfWeek,
    RangeInt? lesson,
    String? room,
  }) {
    return SubjectSchedule.from(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      lesson: lesson ?? this.lesson,
      room: room ?? this.room,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'day_of_week': dayOfWeek});
    result.addAll({'lesson_affected': lesson});
    result.addAll({'room': room});

    return result;
  }

  factory SubjectSchedule.fromMap(Map<String, dynamic> map) {
    return SubjectSchedule.from(
      dayOfWeek: map['day_of_week']?.toInt() ?? 0,
      lesson: map['lesson_affected'] ?? RangeInt(start: 0, end: 0),
      room: map['room'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectSchedule.fromJson(String source) =>
      SubjectSchedule.fromMap(json.decode(source));

  @override
  String toString() =>
      'SubjectScheduleStudy(dayOfWeek: $dayOfWeek, lesson: $lesson, room: $room)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectSchedule &&
        other.dayOfWeek == dayOfWeek &&
        other.lesson == lesson &&
        other.room == room;
  }

  @override
  int get hashCode => dayOfWeek.hashCode ^ lesson.hashCode ^ room.hashCode;
}

class ScheduleStudy {
  List<SubjectSchedule> subjectStudyList = [];
  List<RangeInt> weekList = [];

  ScheduleStudy.createDefault()
      : subjectStudyList = [],
        weekList = [];

  ScheduleStudy({
    required this.subjectStudyList,
    required this.weekList,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll(
        {'schedule_list': subjectStudyList.map((x) => x.toMap()).toList()});
    result.addAll({'week_affected': weekList.map((x) => x.toMap()).toList()});

    return result;
  }

  factory ScheduleStudy.fromMap(Map<String, dynamic> map) {
    return ScheduleStudy(
      subjectStudyList: List<SubjectSchedule>.from(
          map['schedule_list']?.map((x) => SubjectSchedule.fromMap(x))),
      weekList:
      List<RangeInt>.from(map['week_affected']?.map((x) => RangeInt.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleStudy.fromJson(String source) =>
      ScheduleStudy.fromMap(json.decode(source));
}

class ScheduleExam {
  int date;
  String room;
  bool isGlobal;
  String group;

  ScheduleExam.createDefault()
      : date = 0,
        room = '',
        isGlobal = false,
        group = '';

  ScheduleExam({
    required this.date,
    required this.room,
    required this.isGlobal,
    required this.group,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'date': date});
    result.addAll({'room': room});
    result.addAll({'is_global': isGlobal});
    result.addAll({'group': group});

    return result;
  }

  factory ScheduleExam.fromMap(Map<String, dynamic> map) {
    return ScheduleExam(
      date: map['date']?.toInt() ?? 0,
      room: map['room'] ?? '',
      isGlobal: map['is_global'] ?? false,
      group: map['group'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleExam.fromJson(String source) =>
      ScheduleExam.fromMap(json.decode(source));
}

class SubjectFee {
  SubjectCode id = SubjectCode();
  String name = '';
  int credit = 0;
  bool isHighQuality = false;
  double price = 0;
  bool isDebt = false;
  bool isReStudy = false;
  String? confirmedPaymentAt;

  SubjectFee.createDefault();

  SubjectFee({
    required this.id,
    required this.name,
    required this.credit,
    required this.isHighQuality,
    required this.price,
    required this.isDebt,
    required this.isReStudy,
    this.confirmedPaymentAt,
  });

  SubjectFee copyWith({
    SubjectCode? id,
    String? name,
    int? credit,
    bool? isHighQuality,
    double? price,
    bool? isDebt,
    bool? isReStudy,
    String? confirmedPaymentAt,
  }) {
    return SubjectFee(
      id: id ?? this.id,
      name: name ?? this.name,
      credit: credit ?? this.credit,
      isHighQuality: isHighQuality ?? this.isHighQuality,
      price: price ?? this.price,
      isDebt: isDebt ?? this.isDebt,
      isReStudy: isReStudy ?? this.isReStudy,
      confirmedPaymentAt: confirmedPaymentAt ?? this.confirmedPaymentAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id.toMap()});
    result.addAll({'name': name});
    result.addAll({'credit': credit});
    result.addAll({'is_high_quality': isHighQuality});
    result.addAll({'price': price});
    result.addAll({'is_debt': isDebt});
    result.addAll({'is_restudy': isReStudy});
    if (confirmedPaymentAt != null) {
      result.addAll({'verified_payment_at': confirmedPaymentAt});
    }

    return result;
  }

  factory SubjectFee.fromMap(Map<String, dynamic> map) {
    return SubjectFee(
      id: map['id'] == null ? SubjectCode() : SubjectCode.fromMap(map['id']!),
      name: map['name'] ?? '',
      credit: map['credit']?.toInt() ?? 0,
      isHighQuality: map['is_high_quality'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      isDebt: map['is_debt'] ?? false,
      isReStudy: map['is_restudy'] ?? false,
      confirmedPaymentAt: map['verified_payment_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectFee.fromJson(String source) =>
      SubjectFee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectFee(name: $name, credit: $credit, isHighQuality: $isHighQuality, price: $price, isDebt: $isDebt, isReStudy: $isReStudy, confirmedPaymentAt: $confirmedPaymentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectFee &&
        other.name == name &&
        other.credit == credit &&
        other.isHighQuality == isHighQuality &&
        other.price == price &&
        other.isDebt == isDebt &&
        other.isReStudy == isReStudy &&
        other.confirmedPaymentAt == confirmedPaymentAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    credit.hashCode ^
    isHighQuality.hashCode ^
    price.hashCode ^
    isDebt.hashCode ^
    isReStudy.hashCode ^
    confirmedPaymentAt.hashCode;
  }
}

class StudentInformation {
  String name;
  String dateOfBirth;
  String birthPlace;
  String gender;
  String ethnicity;
  String nationality;
  String nationalIdCard;
  String nationalIdCardIssueDate;
  String nationalIdCardIssuePlace;
  String citizenIdCard;
  String citizenIdCardIssueDate;
  String religion;
  String accountBankId;
  String accountBankName;
  String hIId;
  String hIExpireDate;
  String specialization;
  String schoolClass;
  String trainingProgramPlan;
  String trainingProgramPlan2;
  String schoolEmail;
  String personalEmail;
  String schoolEmailInitPass;
  String facebookUrl;
  String phoneNumber;
  String address;
  String addressFrom;
  String addressCity;
  String addressDistrict;
  String addressSubDistrict;
  String studentId;

  StudentInformation({
    required this.name,
    required this.dateOfBirth,
    required this.birthPlace,
    required this.gender,
    required this.ethnicity,
    required this.nationality,
    required this.nationalIdCard,
    required this.nationalIdCardIssueDate,
    required this.nationalIdCardIssuePlace,
    required this.citizenIdCard,
    required this.citizenIdCardIssueDate,
    required this.religion,
    required this.accountBankId,
    required this.accountBankName,
    required this.hIId,
    required this.hIExpireDate,
    required this.specialization,
    required this.schoolClass,
    required this.trainingProgramPlan,
    required this.trainingProgramPlan2,
    required this.schoolEmail,
    required this.personalEmail,
    required this.schoolEmailInitPass,
    required this.facebookUrl,
    required this.phoneNumber,
    required this.address,
    required this.addressFrom,
    required this.addressCity,
    required this.addressDistrict,
    required this.addressSubDistrict,
    required this.studentId,
  });

  StudentInformation copyWith({
    String? name,
    String? dateOfBirth,
    String? birthPlace,
    String? gender,
    String? ethnicity,
    String? nationality,
    String? nationalIdCard,
    String? nationalIdCardIssueDate,
    String? nationalIdCardIssuePlace,
    String? citizenIdCard,
    String? citizenIdCardIssueDate,
    String? religion,
    String? accountBankId,
    String? accountBankName,
    String? hIId,
    String? hIExpireDate,
    String? specialization,
    String? schoolClass,
    String? trainingProgramPlan,
    String? trainingProgramPlan2,
    String? schoolEmail,
    String? personalEmail,
    String? schoolEmailInitPass,
    String? facebookUrl,
    String? phoneNumber,
    String? address,
    String? addressFrom,
    String? addressCity,
    String? addressDistrict,
    String? addressSubDistrict,
    String? studentId,
  }) {
    return StudentInformation(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      ethnicity: ethnicity ?? this.ethnicity,
      nationality: nationality ?? this.nationality,
      nationalIdCard: nationalIdCard ?? this.nationalIdCard,
      nationalIdCardIssueDate:
      nationalIdCardIssueDate ?? this.nationalIdCardIssueDate,
      nationalIdCardIssuePlace:
      nationalIdCardIssuePlace ?? this.nationalIdCardIssuePlace,
      citizenIdCard: citizenIdCard ?? this.citizenIdCard,
      citizenIdCardIssueDate:
      citizenIdCardIssueDate ?? this.citizenIdCardIssueDate,
      religion: religion ?? this.religion,
      accountBankId: accountBankId ?? this.accountBankId,
      accountBankName: accountBankName ?? this.accountBankName,
      hIId: hIId ?? this.hIId,
      hIExpireDate: hIExpireDate ?? this.hIExpireDate,
      specialization: specialization ?? this.specialization,
      schoolClass: schoolClass ?? this.schoolClass,
      trainingProgramPlan: trainingProgramPlan ?? this.trainingProgramPlan,
      trainingProgramPlan2: trainingProgramPlan2 ?? this.trainingProgramPlan2,
      schoolEmail: schoolEmail ?? this.schoolEmail,
      personalEmail: personalEmail ?? this.personalEmail,
      schoolEmailInitPass: schoolEmailInitPass ?? this.schoolEmailInitPass,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      addressFrom: addressFrom ?? this.addressFrom,
      addressCity: addressCity ?? this.addressCity,
      addressDistrict: addressDistrict ?? this.addressDistrict,
      addressSubDistrict: addressSubDistrict ?? this.addressSubDistrict,
      studentId: studentId ?? this.studentId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'date_of_birth': dateOfBirth});
    result.addAll({'birth_pace': birthPlace});
    result.addAll({'gender': gender});
    result.addAll({'ethnicity': ethnicity});
    result.addAll({'nationality': nationality});
    result.addAll({'national_id_card': nationalIdCard});
    result.addAll({'national_id_card_issue_date': nationalIdCardIssueDate});
    result.addAll({'national_id_card_issue_place': nationalIdCardIssuePlace});
    result.addAll({'citizen_id_card': citizenIdCard});
    result.addAll({'citizen_id_card_issue_date': citizenIdCardIssueDate});
    result.addAll({'religion': religion});
    result.addAll({'account_bank_id': accountBankId});
    result.addAll({'account_bank_name': accountBankName});
    result.addAll({'hi_id': hIId});
    result.addAll({'hi_expire_date': hIExpireDate});
    result.addAll({'specialization': specialization});
    result.addAll({'school_class': schoolClass});
    result.addAll({'training_program_plan': trainingProgramPlan});
    result.addAll({'training_program_plan_2': trainingProgramPlan2});
    result.addAll({'school_email': schoolEmail});
    result.addAll({'personal_email': personalEmail});
    result.addAll({'schoolEmailInitPass': schoolEmailInitPass});
    result.addAll({'facebook_url': facebookUrl});
    result.addAll({'phone_number': phoneNumber});
    result.addAll({'address': address});
    result.addAll({'address_from': addressFrom});
    result.addAll({'address_city': addressCity});
    result.addAll({'address_district': addressDistrict});
    result.addAll({'address_sub_district': addressSubDistrict});
    result.addAll({'student_id': studentId});

    return result;
  }

  factory StudentInformation.fromMap(Map<String, dynamic> map) {
    return StudentInformation(
      name: map['name'] ?? '',
      dateOfBirth: map['date_of_birth'] ?? '',
      birthPlace: map['birth_pace'] ?? '',
      gender: map['gender'] ?? '',
      ethnicity: map['ethnicity'] ?? '',
      nationality: map['nationality'] ?? '',
      nationalIdCard: map['national_id_card'] ?? '',
      nationalIdCardIssueDate: map['national_id_card_issue_date'] ?? '',
      nationalIdCardIssuePlace: map['national_id_card_issue_place'] ?? '',
      citizenIdCard: map['citizen_id_card'] ?? '',
      citizenIdCardIssueDate: map['citizen_id_card_issue_date'] ?? '',
      religion: map['religion'] ?? '',
      accountBankId: map['account_bank_id'] ?? '',
      accountBankName: map['account_bank_name'] ?? '',
      hIId: map['hi_id'] ?? '',
      hIExpireDate: map['hi_expire_date'] ?? '',
      specialization: map['specialization'] ?? '',
      schoolClass: map['school_class'] ?? '',
      trainingProgramPlan: map['training_program_plan'] ?? '',
      trainingProgramPlan2: map['training_program_plan_2'] ?? '',
      schoolEmail: map['school_email'] ?? '',
      personalEmail: map['personal_email'] ?? '',
      schoolEmailInitPass: map['schoolEmailInitPass'] ?? '',
      facebookUrl: map['facebook_url'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      address: map['address'] ?? '',
      addressFrom: map['address_from'] ?? '',
      addressCity: map['address_city'] ?? '',
      addressDistrict: map['address_district'] ?? '',
      addressSubDistrict: map['address_sub_district'] ?? '',
      studentId: map['student_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentInformation.fromJson(String source) =>
      StudentInformation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AccountInformation(name: $name, dateOfBirth: $dateOfBirth, birthPlace: $birthPlace, gender: $gender, ethnicity: $ethnicity, nationality: $nationality, nationalIdCard: $nationalIdCard, nationalIdCardIssueDate: $nationalIdCardIssueDate, nationalIdCardIssuePlace: $nationalIdCardIssuePlace, citizenIdCard: $citizenIdCard, citizenIdCardIssueDate: $citizenIdCardIssueDate, religion: $religion, accountBankId: $accountBankId, accountBankName: $accountBankName, hIId: $hIId, hIExpireDate: $hIExpireDate, specialization: $specialization, schoolClass: $schoolClass, trainingProgramPlan: $trainingProgramPlan, trainingProgramPlan2: $trainingProgramPlan2, schoolEmail: $schoolEmail, personalEmail: $personalEmail, schoolEmailInitPass: $schoolEmailInitPass, facebookUrl: $facebookUrl, phoneNumber: $phoneNumber, address: $address, addressFrom: $addressFrom, addressCity: $addressCity, addressDistrict: $addressDistrict, addressSubDistrict: $addressSubDistrict, studentId: $studentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentInformation &&
        other.name == name &&
        other.dateOfBirth == dateOfBirth &&
        other.birthPlace == birthPlace &&
        other.gender == gender &&
        other.ethnicity == ethnicity &&
        other.nationality == nationality &&
        other.nationalIdCard == nationalIdCard &&
        other.nationalIdCardIssueDate == nationalIdCardIssueDate &&
        other.nationalIdCardIssuePlace == nationalIdCardIssuePlace &&
        other.citizenIdCard == citizenIdCard &&
        other.citizenIdCardIssueDate == citizenIdCardIssueDate &&
        other.religion == religion &&
        other.accountBankId == accountBankId &&
        other.accountBankName == accountBankName &&
        other.hIId == hIId &&
        other.hIExpireDate == hIExpireDate &&
        other.specialization == specialization &&
        other.schoolClass == schoolClass &&
        other.trainingProgramPlan == trainingProgramPlan &&
        other.trainingProgramPlan2 == trainingProgramPlan2 &&
        other.schoolEmail == schoolEmail &&
        other.personalEmail == personalEmail &&
        other.schoolEmailInitPass == schoolEmailInitPass &&
        other.facebookUrl == facebookUrl &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.addressFrom == addressFrom &&
        other.addressCity == addressCity &&
        other.addressDistrict == addressDistrict &&
        other.addressSubDistrict == addressSubDistrict &&
        other.studentId == studentId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    dateOfBirth.hashCode ^
    birthPlace.hashCode ^
    gender.hashCode ^
    ethnicity.hashCode ^
    nationality.hashCode ^
    nationalIdCard.hashCode ^
    nationalIdCardIssueDate.hashCode ^
    nationalIdCardIssuePlace.hashCode ^
    citizenIdCard.hashCode ^
    citizenIdCardIssueDate.hashCode ^
    religion.hashCode ^
    accountBankId.hashCode ^
    accountBankName.hashCode ^
    hIId.hashCode ^
    hIExpireDate.hashCode ^
    specialization.hashCode ^
    schoolClass.hashCode ^
    trainingProgramPlan.hashCode ^
    trainingProgramPlan2.hashCode ^
    schoolEmail.hashCode ^
    personalEmail.hashCode ^
    schoolEmailInitPass.hashCode ^
    facebookUrl.hashCode ^
    phoneNumber.hashCode ^
    address.hashCode ^
    addressFrom.hashCode ^
    addressCity.hashCode ^
    addressDistrict.hashCode ^
    addressSubDistrict.hashCode ^
    studentId.hashCode;
  }
}

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

    result.addAll({'school_year_start': schoolYearStart});
    result.addAll({'school_year_current': schoolYearCurrent});
    result.addAll({'credit_collected': creditCollected});
    result.addAll({'avg_train_score_4': avgTrainingScore4});
    result.addAll({'avg_social': avgSocial});

    return result;
  }

  factory TrainingSummary.fromMap(Map<String, dynamic> map) {
    return TrainingSummary(
      schoolYearStart: map['school_year_start'] ?? '',
      schoolYearCurrent: map['school_year_current'] ?? '',
      creditCollected: map['credit_collected']?.toDouble() ?? 0.0,
      avgTrainingScore4: map['avg_train_score_4']?.toDouble() ?? 0.0,
      avgSocial: map['avg_social']?.toDouble() ?? 0.0,
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

class GraduateStatus {
  final bool hasSigGDTC;
  final bool hasSigGDQP;
  final bool hasSigEnglish;
  final bool hasSigIT;
  final bool hasQualifiedGraduate;
  final String rewardsInfo;
  final String disciplineInfo;
  final String eligibleGraduationThesisStatus;
  final String eligibleGraduationStatus;

  GraduateStatus({
    required this.hasSigGDTC,
    required this.hasSigGDQP,
    required this.hasSigEnglish,
    required this.hasSigIT,
    required this.hasQualifiedGraduate,
    required this.rewardsInfo,
    required this.disciplineInfo,
    required this.eligibleGraduationThesisStatus,
    required this.eligibleGraduationStatus,
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
      rewardsInfo: info1 ?? this.rewardsInfo,
      disciplineInfo: info2 ?? this.disciplineInfo,
      eligibleGraduationThesisStatus: info3 ?? this.eligibleGraduationThesisStatus,
      eligibleGraduationStatus:
      approveGraduateProcessInfo ?? this.eligibleGraduationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'has_sig_physical_education': hasSigGDTC});
    result.addAll({'has_sig_national_defense_education': hasSigGDQP});
    result.addAll({'has_sig_english': hasSigEnglish});
    result.addAll({'has_sig_it': hasSigIT});
    result.addAll({'has_qualified_graduate': hasQualifiedGraduate});
    result.addAll({'rewards_info': rewardsInfo});
    result.addAll({'discipline_info': disciplineInfo});
    result.addAll({'eligible_graduation_thesis_status': eligibleGraduationThesisStatus});
    result.addAll({'eligible_graduation_status': eligibleGraduationStatus});

    return result;
  }

  factory GraduateStatus.fromMap(Map<String, dynamic> map) {
    return GraduateStatus(
      hasSigGDTC: map['has_sig_physical_education'] ?? false,
      hasSigGDQP: map['has_sig_national_defense_education'] ?? false,
      hasSigEnglish: map['has_sig_english'] ?? false,
      hasSigIT: map['has_sig_it'] ?? false,
      hasQualifiedGraduate: map['has_qualified_graduate'] ?? false,
      rewardsInfo: map['rewards_info'] ?? '',
      disciplineInfo: map['discipline_info'] ?? '',
      eligibleGraduationThesisStatus: map['eligible_graduation_thesis_status'] ?? '',
      eligibleGraduationStatus: map['eligible_graduation_status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GraduateStatus.fromJson(String source) =>
      GraduateStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GraduateStatus(hasSigGDTC: $hasSigGDTC, hasSigGDQP: $hasSigGDQP, hasSigEnglish: $hasSigEnglish, hasSigIT: $hasSigIT, hasQualifiedGraduate: $hasQualifiedGraduate, rewardsInfo: $rewardsInfo, disciplineInfo: $disciplineInfo, eligibleGraduationThesisStatus: $eligibleGraduationThesisStatus, eligibleGraduationStatus: $eligibleGraduationStatus)';
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
        other.rewardsInfo == rewardsInfo &&
        other.disciplineInfo == disciplineInfo &&
        other.eligibleGraduationThesisStatus == eligibleGraduationThesisStatus &&
        other.eligibleGraduationStatus == eligibleGraduationStatus;
  }

  @override
  int get hashCode {
    return hasSigGDTC.hashCode ^
    hasSigGDQP.hashCode ^
    hasSigEnglish.hashCode ^
    hasSigIT.hashCode ^
    hasQualifiedGraduate.hashCode ^
    rewardsInfo.hashCode ^
    disciplineInfo.hashCode ^
    eligibleGraduationThesisStatus.hashCode ^
    eligibleGraduationStatus.hashCode;
  }
}

class SubjectResult {
  final int index;
  final String schoolYear;
  final bool isExtendedSemester;
  final SubjectCode id;
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
  final double? pointTT;
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
    this.pointTT,
    this.resultT4,
    this.resultT10,
    this.resultByCharacter,
    required this.isReStudy,
  });

  SubjectResult copyWith({
    int? index,
    String? schoolYear,
    bool? isExtendedSemester,
    SubjectCode? id,
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
    double? pointTT,
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
      pointTT: pointTT ?? this.pointTT,
      resultT4: resultT4 ?? this.resultT4,
      resultT10: resultT10 ?? this.resultT10,
      resultByCharacter: resultByCharacter ?? this.resultByCharacter,
      isReStudy: isReStudy ?? this.isReStudy,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'index': index});
    result.addAll({'school_year': schoolYear});
    result.addAll({'is_extended_summer': isExtendedSemester});
    result.addAll({'id': id.toMap()});
    result.addAll({'name': name});
    result.addAll({'credit': credit});
    if (pointFormula != null) {
      result.addAll({'point_formula': pointFormula});
    }
    if (pointBT != null) {
      result.addAll({'point_bt': pointBT});
    }
    if (pointBV != null) {
      result.addAll({'point_bv': pointBV});
    }
    if (pointCC != null) {
      result.addAll({'point_cc': pointCC});
    }
    if (pointCK != null) {
      result.addAll({'point_ck': pointCK});
    }
    if (pointGK != null) {
      result.addAll({'point_gk': pointGK});
    }
    if (pointQT != null) {
      result.addAll({'point_qt': pointQT});
    }
    if (pointTH != null) {
      result.addAll({'point_th': pointTH});
    }
    if (pointTT != null) {
      result.addAll({'point_tt': pointTT});
    }
    if (resultT4 != null) {
      result.addAll({'result_t4': resultT4});
    }
    if (resultT10 != null) {
      result.addAll({'result_t10': resultT10});
    }
    if (resultByCharacter != null) {
      result.addAll({'result_by_char': resultByCharacter});
    }
    result.addAll({'is_restudy': isReStudy});

    return result;
  }

  factory SubjectResult.fromMap(Map<String, dynamic> map) {
    return SubjectResult(
      index: map['index']?.toInt() ?? 0,
      schoolYear: map['school_year'] ?? '',
      isExtendedSemester: map['is_extended_summer'] ?? false,
      id: SubjectCode.fromMap(map['id']),
      name: map['name'] ?? '',
      credit: map['credit']?.toDouble() ?? 0.0,
      pointFormula: map['point_formula'],
      pointBT: map['point_bt']?.toDouble(),
      pointBV: map['point_bv']?.toDouble(),
      pointCC: map['point_cc']?.toDouble(),
      pointCK: map['point_ck']?.toDouble(),
      pointGK: map['point_gk']?.toDouble(),
      pointQT: map['point_qt']?.toDouble(),
      pointTH: map['point_th']?.toDouble(),
      pointTT: map['point_tt']?.toDouble(),
      resultT4: map['result_t4']?.toDouble(),
      resultT10: map['result_t10']?.toDouble(),
      resultByCharacter: map['result_by_char'],
      isReStudy: map['is_restudy'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectResult.fromJson(String source) =>
      SubjectResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubjectResult(index: $index, schoolYear: $schoolYear, isExtendedSemester: $isExtendedSemester, id: $id, name: $name, credit: $credit, pointFormula: $pointFormula, pointBT: $pointBT, pointBV: $pointBV, pointCC: $pointCC, pointCK: $pointCK, pointGK: $pointGK, pointQT: $pointQT, pointTH: $pointTH, pointTT: $pointTT, resultT4: $resultT4, resultT10: $resultT10, resultByCharacter: $resultByCharacter, isReStudy: $isReStudy)';
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
        other.pointTT == pointTT &&
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
    pointTT.hashCode ^
    resultT4.hashCode ^
    resultT10.hashCode ^
    resultByCharacter.hashCode ^
    isReStudy.hashCode;
  }
}

class TrainingResult {
  final TrainingSummary trainingSummary;
  final GraduateStatus graduateStatus;
  final List<SubjectResult> subjectResultList;

  TrainingResult({
    required this.trainingSummary,
    required this.graduateStatus,
    required this.subjectResultList,
  });

  TrainingResult copyWith({
    TrainingSummary? trainingSummary,
    GraduateStatus? graduateStatus,
    List<SubjectResult>? subjectResultList,
  }) {
    return TrainingResult(
      trainingSummary: trainingSummary ?? this.trainingSummary,
      graduateStatus: graduateStatus ?? this.graduateStatus,
      subjectResultList: subjectResultList ?? this.subjectResultList,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'training_summary': trainingSummary.toMap()});
    result.addAll({'graduate_status': graduateStatus.toMap()});
    result.addAll({
      'subject_result': subjectResultList.map((x) => x.toMap()).toList()
    });

    return result;
  }

  factory TrainingResult.fromMap(Map<String, dynamic> map) {
    return TrainingResult(
      trainingSummary: TrainingSummary.fromMap(map['training_summary']),
      graduateStatus: GraduateStatus.fromMap(map['graduate_status']),
      subjectResultList: List<SubjectResult>.from(
          map['subject_result']?.map((x) => SubjectResult.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainingResult.fromJson(String source) =>
      TrainingResult.fromMap(json.decode(source));

  @override
  String toString() =>
      'AccountTrainingStatus(trainingSummary: $trainingSummary, graduateStatus: $graduateStatus, subjectResultList: $subjectResultList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrainingResult &&
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
