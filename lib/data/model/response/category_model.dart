// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<Category> categories;
  List<PopluarProjectList> popluarProjectList;
  List<ServiceProvider> serviceProvider;

  CategoryModel({
    required this.categories,
    required this.popluarProjectList,
    required this.serviceProvider,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    popluarProjectList: List<PopluarProjectList>.from(json["popluar_project_list"].map((x) => PopluarProjectList.fromJson(x))),
    serviceProvider: List<ServiceProvider>.from(json["service_provider"].map((x) => ServiceProvider.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "popluar_project_list": List<dynamic>.from(popluarProjectList.map((x) => x.toJson())),
    "service_provider": List<dynamic>.from(serviceProvider.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String name;
  String description;
  String tag;
  String image;
  dynamic title;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.image,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    tag: json["tag"],
    image: json["image"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "tag": tag,
    "image": image,
    "title": title,
  };
}

class PopluarProjectList {
  String image;
  dynamic label;
  dynamic title;
  dynamic avgPriceDescription;
  int categoryId;
  int subCategoryId;
  String gardeningServiceIds;
  String categoryImage;
  String categoryName;
  String categoryDescription;
  String subCategoryImage;
  String subCategoryDescription;
  String subCategoryName;

  PopluarProjectList({
    required this.image,
    required this.label,
    required this.title,
    required this.avgPriceDescription,
    required this.categoryId,
    required this.subCategoryId,
    required this.gardeningServiceIds,
    required this.categoryImage,
    required this.categoryName,
    required this.categoryDescription,
    required this.subCategoryImage,
    required this.subCategoryDescription,
    required this.subCategoryName,
  });

  factory PopluarProjectList.fromJson(Map<String, dynamic> json) => PopluarProjectList(
    image: json["image"],
    label: json["label"],
    title: json["title"],
    avgPriceDescription: json["avg_price_description"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    gardeningServiceIds: json["gardening_service_ids"],
    categoryImage: json["category_image"],
    categoryName: json["category_name"],
    categoryDescription: json["category_description"],
    subCategoryImage: json["sub_category_image"],
    subCategoryDescription: json["sub_category_description"],
    subCategoryName: json["sub_category_name"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "label": label,
    "title": title,
    "avg_price_description": avgPriceDescription,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "gardening_service_ids": gardeningServiceIds,
    "category_image": categoryImage,
    "category_name": categoryName,
    "category_description": categoryDescription,
    "sub_category_image": subCategoryImage,
    "sub_category_description": subCategoryDescription,
    "sub_category_name": subCategoryName,
  };
}

class ServiceProvider {
  int id;
  String aboutMe;
  String categoryIds;
  String fullName;
  String profileImage;
  int rating;
  int totalReview;
  String? review;
  dynamic distance;
  dynamic fullAddress;
  List<Category> categories;

  ServiceProvider({
    required this.id,
    required this.aboutMe,
    required this.categoryIds,
    required this.fullName,
    required this.profileImage,
    required this.rating,
    required this.totalReview,
    required this.review,
    required this.distance,
    required this.fullAddress,
    required this.categories,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
    id: json["id"],
    aboutMe: json["about_me"],
    categoryIds: json["category_ids"],
    fullName: json["full_name"],
    profileImage: json["profile_image"],
    rating: json["rating"],
    totalReview: json["total_review"],
    review: json["review"],
    distance: json["distance"],
    fullAddress: json["full_address"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "about_me": aboutMe,
    "category_ids": categoryIds,
    "full_name": fullName,
    "profile_image": profileImage,
    "rating": rating,
    "total_review": totalReview,
    "review": review,
    "distance": distance,
    "full_address": fullAddress,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}
