import 'package:flutter_demo_structure/data/model/response/otp_model.dart';

import '../../core/api/base_response/base_response.dart';
import '../model/response/sign_up_model.dart';

abstract class AuthenticationRepository {
  Future<BaseResponse<SignUpModel>> signUp(Map<String, dynamic> data);
  Future<BaseResponse<OtpModel>> checkOtp(Map<String, dynamic> data);
}
