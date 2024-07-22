import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/api/base_response/base_response.dart';
import '../model/response/otp_model.dart';
import '../model/response/sign_up_model.dart';

part 'authentication_api.g.dart';

@RestApi()
abstract class SignUpApi {
  factory SignUpApi(Dio dio) = _SignUpApi;

  @POST('user/signup')
  Future<BaseResponse<SignUpModel>> signUp(@Body() Map<String, dynamic> data);

  @POST('user/send_otp')
  Future<BaseResponse<OtpModel>> checkOtp(@Body() Map<String, dynamic> data);
}
