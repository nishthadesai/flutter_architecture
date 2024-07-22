import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_structure/core/api/base_response/base_response.dart';
import 'package:flutter_demo_structure/core/exceptions/app_exceptions.dart';
import 'package:flutter_demo_structure/core/exceptions/dio_exception_util.dart';
import 'package:flutter_demo_structure/core/locator/locator.dart';
import 'package:flutter_demo_structure/data/repository_impl/home_repo_impl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/response/category_model.dart';
import '../../../../data/model/response/image_model.dart';
import '../../../../data/model/response/sub_category_model.dart';
import '../../../../generated/l10n.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  BaseResponse<CategoryModel>? categoryResponse;
  @observable
  ImageModel? imageResponse;
  @observable
  String? errorMessage;

  @observable
  BaseResponse<List<SubcategoryListModel>>? subcategoryResponse;

  @observable
  List<ReactionDisposer>? disposer;

  @observable
  String currentAddress = S.current.yourCurrentLocation;

  @observable
  String fullAddress = "";

  @observable
  Position? currentPosition;

  @observable
  bool isLoading = false;

  @action
  Future categoryData(Map<String, dynamic> data) async {
    try {
      isLoading = true;
      errorMessage = null;
      categoryResponse = await ObservableFuture<BaseResponse<CategoryModel>>(
          homeRepo.categoryData(data));
      debugPrint("Error:$errorMessage");
      // if (categoryResponse != null) {
      //   return categoryResponse;
      // } else {
      //   return Center(child: Text("No data found"));
      // }
    } on DioException catch (e) {
      errorMessage = DioExceptionUtil.handleError(e);
      // throw DioExceptionUtil.handleError(e);
    } on AppException catch (e) {
      errorMessage = e.toString();
      // throw e;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future subcategoryData(Map<String, dynamic> data) async {
    try {
      subcategoryResponse =
          await ObservableFuture<BaseResponse<List<SubcategoryListModel>>>(
              homeRepo.subcategoryData(data));
      if (subcategoryResponse != null) {
        return subcategoryResponse;
      } else {
        return Center(child: Text("No data found"));
      }
    } on DioException catch (e) {
      errorMessage = DioExceptionUtil.handleError(e);
      throw DioExceptionUtil.handleError(e);
    } on AppException catch (e) {
      errorMessage = e.toString();
      throw e;
    }
  }

  @action
  Future<void> getCurrentPosition() async {
    // final hasPermission = await handleLocationPermission();
    // if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @action
  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress = '${place.subLocality}, ${place.locality}';
      fullAddress =
          '${place.thoroughfare}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @action
  launchURL() async {
    final url = 'https://www.google.com/maps/place/$fullAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @action
  Future uploadImage(File data) async {
    errorMessage = null;
    isLoading = true;
    try {
      imageResponse = await homeRepo.uploadImage(data);
    } on DioException catch (e) {
      errorMessage = DioExceptionUtil.handleError(e);
      throw DioExceptionUtil.handleError(e);
    } on AppException catch (e) {
      errorMessage = e.toString();
      throw e;
    }
  }
}

final homeStore = locator<HomeStore>();
