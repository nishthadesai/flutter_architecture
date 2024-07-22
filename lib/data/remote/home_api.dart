import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/api/base_response/base_response.dart';
import '../model/response/category_model.dart';
import '../model/response/sub_category_model.dart';

part 'home_api.g.dart';

@RestApi()
abstract class HomeApi {
  factory HomeApi(Dio dio) = _HomeApi;

  @POST('/user/home')
  Future<BaseResponse<CategoryModel>> categoryData(
      @Body() Map<String, dynamic> data);

  @POST('user/sub_category_list')
  Future<BaseResponse<List<SubcategoryListModel>>> subcategoryData(
      @Body() Map<String, dynamic> data);
}
