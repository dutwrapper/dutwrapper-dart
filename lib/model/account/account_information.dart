import 'dart:convert';

class AccountInformation {
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

  AccountInformation({
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

  AccountInformation copyWith({
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
    return AccountInformation(
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
    result.addAll({'dateOfBirth': dateOfBirth});
    result.addAll({'birthPlace': birthPlace});
    result.addAll({'gender': gender});
    result.addAll({'ethnicity': ethnicity});
    result.addAll({'nationality': nationality});
    result.addAll({'nationalIdCard': nationalIdCard});
    result.addAll({'nationalIdCardIssueDate': nationalIdCardIssueDate});
    result.addAll({'nationalIdCardIssuePlace': nationalIdCardIssuePlace});
    result.addAll({'citizenIdCard': citizenIdCard});
    result.addAll({'citizenIdCardIssueDate': citizenIdCardIssueDate});
    result.addAll({'religion': religion});
    result.addAll({'accountBankId': accountBankId});
    result.addAll({'accountBankName': accountBankName});
    result.addAll({'hIId': hIId});
    result.addAll({'hIExpireDate': hIExpireDate});
    result.addAll({'specialization': specialization});
    result.addAll({'schoolClass': schoolClass});
    result.addAll({'trainingProgramPlan': trainingProgramPlan});
    result.addAll({'trainingProgramPlan2': trainingProgramPlan2});
    result.addAll({'schoolEmail': schoolEmail});
    result.addAll({'personalEmail': personalEmail});
    result.addAll({'schoolEmailInitPass': schoolEmailInitPass});
    result.addAll({'facebookUrl': facebookUrl});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'address': address});
    result.addAll({'addressFrom': addressFrom});
    result.addAll({'addressCity': addressCity});
    result.addAll({'addressDistrict': addressDistrict});
    result.addAll({'addressSubDistrict': addressSubDistrict});
    result.addAll({'studentId': studentId});

    return result;
  }

  factory AccountInformation.fromMap(Map<String, dynamic> map) {
    return AccountInformation(
      name: map['name'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      birthPlace: map['birthPlace'] ?? '',
      gender: map['gender'] ?? '',
      ethnicity: map['ethnicity'] ?? '',
      nationality: map['nationality'] ?? '',
      nationalIdCard: map['nationalIdCard'] ?? '',
      nationalIdCardIssueDate: map['nationalIdCardIssueDate'] ?? '',
      nationalIdCardIssuePlace: map['nationalIdCardIssuePlace'] ?? '',
      citizenIdCard: map['citizenIdCard'] ?? '',
      citizenIdCardIssueDate: map['citizenIdCardIssueDate'] ?? '',
      religion: map['religion'] ?? '',
      accountBankId: map['accountBankId'] ?? '',
      accountBankName: map['accountBankName'] ?? '',
      hIId: map['hIId'] ?? '',
      hIExpireDate: map['hIExpireDate'] ?? '',
      specialization: map['specialization'] ?? '',
      schoolClass: map['schoolClass'] ?? '',
      trainingProgramPlan: map['trainingProgramPlan'] ?? '',
      trainingProgramPlan2: map['trainingProgramPlan2'] ?? '',
      schoolEmail: map['schoolEmail'] ?? '',
      personalEmail: map['personalEmail'] ?? '',
      schoolEmailInitPass: map['schoolEmailInitPass'] ?? '',
      facebookUrl: map['facebookUrl'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      addressFrom: map['addressFrom'] ?? '',
      addressCity: map['addressCity'] ?? '',
      addressDistrict: map['addressDistrict'] ?? '',
      addressSubDistrict: map['addressSubDistrict'] ?? '',
      studentId: map['studentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountInformation.fromJson(String source) =>
      AccountInformation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AccountInformation(name: $name, dateOfBirth: $dateOfBirth, birthPlace: $birthPlace, gender: $gender, ethnicity: $ethnicity, nationality: $nationality, nationalIdCard: $nationalIdCard, nationalIdCardIssueDate: $nationalIdCardIssueDate, nationalIdCardIssuePlace: $nationalIdCardIssuePlace, citizenIdCard: $citizenIdCard, citizenIdCardIssueDate: $citizenIdCardIssueDate, religion: $religion, accountBankId: $accountBankId, accountBankName: $accountBankName, hIId: $hIId, hIExpireDate: $hIExpireDate, specialization: $specialization, schoolClass: $schoolClass, trainingProgramPlan: $trainingProgramPlan, trainingProgramPlan2: $trainingProgramPlan2, schoolEmail: $schoolEmail, personalEmail: $personalEmail, schoolEmailInitPass: $schoolEmailInitPass, facebookUrl: $facebookUrl, phoneNumber: $phoneNumber, address: $address, addressFrom: $addressFrom, addressCity: $addressCity, addressDistrict: $addressDistrict, addressSubDistrict: $addressSubDistrict, studentId: $studentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountInformation &&
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
