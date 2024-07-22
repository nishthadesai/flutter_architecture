import 'dart:io';

import 'package:flutter_demo_structure/data/model/response/category_model.dart';
import 'package:flutter_demo_structure/data/model/response/sub_category_model.dart';

import '../../core/api/base_response/base_response.dart';

abstract class HomeRepository {
  Future<BaseResponse<CategoryModel>> categoryData(Map<String, dynamic> data);
  Future<BaseResponse<List<SubcategoryListModel>>> subcategoryData(
      Map<String, dynamic> data);
  Future uploadImage(File image);
}
