// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  String otp;
  String countryCode;
  String phone;

  OtpModel({
    required this.otp,
    required this.countryCode,
    required this.phone,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        otp: json["otp"],
        countryCode: json["country_code"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "country_code": countryCode,
        "phone": phone,
      };
}
