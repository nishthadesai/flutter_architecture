import 'package:dio/dio.dart';
import 'package:flutter_demo_structure/core/exceptions/app_exceptions.dart';
import 'package:flutter_demo_structure/core/exceptions/dio_exception_util.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/data/model/response/otp_model.dart';
import 'package:mobx/mobx.dart';

import '../../../core/api/base_response/base_response.dart';
import '../../../data/model/response/sign_up_model.dart';
import '../../../data/repository_impl/authentication_repo_impl.dart';

part 'authentication_store.g.dart';

///there is a mixin called store so we write with;

class AuthenticationStore = AuthenticationStoreBase with _$AuthenticationStore;

abstract class AuthenticationStoreBase with Store {
  @observable
  BaseResponse<SignUpModel>? signupResponse;

  @observable
  BaseResponse<OtpModel>? otpResponse;
  @observable
  String? errorMessage;

  @observable
  bool isLoading = false;

  @action
  Future signUp(Map<String, dynamic> data) async {
    try {
      isLoading = true;
      errorMessage = null;
      signupResponse = await ObservableFuture<BaseResponse<SignUpModel>>(
          authenticRepo.signUp(data));
    } on DioException catch (e) {
      errorMessage = DioExceptionUtil.handleError(e);
    } on AppException catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future checkOtp(Map<String, dynamic> data) async {
    try {
      errorMessage = null;
      otpResponse = await ObservableFuture<BaseResponse<OtpModel>>(
          authenticRepo.checkOtp(data));
    } on DioException catch (e) {
      errorMessage = DioExceptionUtil.handleError(e);
    } on AppException catch (e) {
      errorMessage = e.toString();
    }
  }
}

final authenticStore = locator<AuthenticationStore>();
