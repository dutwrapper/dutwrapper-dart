import 'dart:convert';

import '../subject_code.dart';

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
    required this.name,
    required this.credit,
    required this.isHighQuality,
    required this.price,
    required this.isDebt,
    required this.isReStudy,
    this.confirmedPaymentAt,
  });

  SubjectFee copyWith({
    String? name,
    int? credit,
    bool? isHighQuality,
    double? price,
    bool? isDebt,
    bool? isReStudy,
    String? confirmedPaymentAt,
  }) {
    return SubjectFee(
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

    result.addAll({'name': name});
    result.addAll({'credit': credit});
    result.addAll({'isHighQuality': isHighQuality});
    result.addAll({'price': price});
    result.addAll({'isDebt': isDebt});
    result.addAll({'isReStudy': isReStudy});
    if (confirmedPaymentAt != null) {
      result.addAll({'confirmedPaymentAt': confirmedPaymentAt});
    }

    return result;
  }

  factory SubjectFee.fromMap(Map<String, dynamic> map) {
    return SubjectFee(
      name: map['name'] ?? '',
      credit: map['credit']?.toInt() ?? 0,
      isHighQuality: map['isHighQuality'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      isDebt: map['isDebt'] ?? false,
      isReStudy: map['isReStudy'] ?? false,
      confirmedPaymentAt: map['confirmedPaymentAt'],
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
