import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_demo_structure/core/api/base_response/base_response.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/data/model/response/category_model.dart';
import 'package:flutter_demo_structure/data/model/response/sub_category_model.dart';
import 'package:flutter_demo_structure/data/remote/home_api.dart';
import 'package:flutter_demo_structure/data/repository/home_repo.dart';

import '../../core/exceptions/dio_exception_util.dart';
import '../model/response/image_model.dart';

class HomeRepoImpl extends HomeRepository {
  Dio dio = Dio();
  HomeApi homeApi;
  HomeRepoImpl({required this.homeApi});

  @override
  Future<BaseResponse<CategoryModel>> categoryData(
      Map<String, dynamic> data) async {
    try {
      final BaseResponse<CategoryModel> response =
          await homeApi.categoryData(data);
      return response;
    } on DioException catch (e) {
      DioExceptionUtil.handleError(e);
      rethrow;
    }
  }

  @override
  Future<BaseResponse<List<SubcategoryListModel>>> subcategoryData(
      Map<String, dynamic> data) async {
    try {
      final BaseResponse<List<SubcategoryListModel>> response =
          await homeApi.subcategoryData(data);
      return response;
    } on DioException catch (e) {
      DioExceptionUtil.handleError(e);
      rethrow;
    }
  }

  @override
  Future uploadImage(File image) async {
    try {
      var options = Options(headers: {'Content-Type': 'multipart/form-data'});
      var formData =
          FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});
      var res = await dio.post('https://api.escuelajs.co/api/v1/files/upload',
          data: formData, options: options);
      return ImageModel.fromJson(res.data);
    } on DioException catch (e) {
      DioExceptionUtil.handleError(e);
      rethrow;
    }
  }
}

final homeRepo = locator<HomeRepoImpl>();
