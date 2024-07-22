// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

SignUpModel signUpModelFromJson(String str) =>
    SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  int id;
  String loginType;
  String userType;
  String countryCode;
  String phone;
  String email;
  String password;
  String socialId;
  String firstName;
  String lastName;
  String profileImage;
  String currency;
  String latitude;
  String longitude;
  String language;
  int isReceiveMarketingNotifications;
  int isSendReceiptsToEmail;
  String loginStatus;
  DateTime lastLogin;
  String timeZone;
  dynamic deleteReason;
  dynamic deleteReasonComment;
  dynamic adminDeleteReason;
  dynamic adminActiveReason;
  dynamic adminInactiveReason;
  int adminId;
  int isActive;
  int isDeleted;
  DateTime insertdate;
  DateTime updatetime;
  String deleteAt;
  String deviceToken;
  String deviceType;
  String token;

  SignUpModel({
    required this.id,
    required this.loginType,
    required this.userType,
    required this.countryCode,
    required this.phone,
    required this.email,
    required this.password,
    required this.socialId,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.language,
    required this.isReceiveMarketingNotifications,
    required this.isSendReceiptsToEmail,
    required this.loginStatus,
    required this.lastLogin,
    required this.timeZone,
    required this.deleteReason,
    required this.deleteReasonComment,
    required this.adminDeleteReason,
    required this.adminActiveReason,
    required this.adminInactiveReason,
    required this.adminId,
    required this.isActive,
    required this.isDeleted,
    required this.insertdate,
    required this.updatetime,
    required this.deleteAt,
    required this.deviceToken,
    required this.deviceType,
    required this.token,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        id: json["id"],
        loginType: json["login_type"],
        userType: json["user_type"],
        countryCode: json["country_code"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        socialId: json["social_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileImage: json["profile_image"],
        currency: json["currency"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        language: json["language"],
        isReceiveMarketingNotifications:
            json["is_receive_marketing_notifications"],
        isSendReceiptsToEmail: json["is_send_receipts_to_email"],
        loginStatus: json["login_status"],
        lastLogin: DateTime.parse(json["last_login"]),
        timeZone: json["time_zone"],
        deleteReason: json["delete_reason"],
        deleteReasonComment: json["delete_reason_comment"],
        adminDeleteReason: json["admin_delete_reason"],
        adminActiveReason: json["admin_active_reason"],
        adminInactiveReason: json["admin_inactive_reason"],
        adminId: json["admin_id"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        insertdate: DateTime.parse(json["insertdate"]),
        updatetime: DateTime.parse(json["updatetime"]),
        deleteAt: json["delete_at"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login_type": loginType,
        "user_type": userType,
        "country_code": countryCode,
        "phone": phone,
        "email": email,
        "password": password,
        "social_id": socialId,
        "first_name": firstName,
        "last_name": lastName,
        "profile_image": profileImage,
        "currency": currency,
        "latitude": latitude,
        "longitude": longitude,
        "language": language,
        "is_receive_marketing_notifications": isReceiveMarketingNotifications,
        "is_send_receipts_to_email": isSendReceiptsToEmail,
        "login_status": loginStatus,
        "last_login": lastLogin.toIso8601String(),
        "time_zone": timeZone,
        "delete_reason": deleteReason,
        "delete_reason_comment": deleteReasonComment,
        "admin_delete_reason": adminDeleteReason,
        "admin_active_reason": adminActiveReason,
        "admin_inactive_reason": adminInactiveReason,
        "admin_id": adminId,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "insertdate": insertdate.toIso8601String(),
        "updatetime": updatetime.toIso8601String(),
        "delete_at": deleteAt,
        "device_token": deviceToken,
        "device_type": deviceType,
        "token": token,
      };
}
