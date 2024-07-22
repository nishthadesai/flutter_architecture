import 'package:dio/dio.dart';
import 'package:flutter_demo_structure/core/api/base_response/base_response.dart';
import 'package:flutter_demo_structure/core/exceptions/dio_exception_util.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/data/model/response/otp_model.dart';
import 'package:flutter_demo_structure/data/model/response/sign_up_model.dart';
import 'package:flutter_demo_structure/data/repository/authentication_repo.dart';

import '../remote/authentication_api.dart';

class AuthenticationRepoImpl extends AuthenticationRepository {
  SignUpApi signUpApi;

  AuthenticationRepoImpl({required this.signUpApi});

  @override
  Future<BaseResponse<SignUpModel>> signUp(Map<String, dynamic> data) async {
    try {
      final BaseResponse<SignUpModel> response = await signUpApi.signUp(data);
      return response;
    } on DioException catch (e) {
      DioExceptionUtil.handleError(e);
      rethrow;
    }
  }

  @override
  Future<BaseResponse<OtpModel>> checkOtp(Map<String, dynamic> data) async {
    try {
      final BaseResponse<OtpModel> response = await signUpApi.checkOtp(data);
      return response;
    } on DioException catch (e) {
      DioExceptionUtil.handleError(e);
      rethrow;
    }
  }
}

final authenticRepo = locator<AuthenticationRepoImpl>();
