// To parse this JSON data, do
//
//     final subcategoryListModel = subcategoryListModelFromJson(jsonString);

import 'dart:convert';

List<SubcategoryListModel> subcategoryListModelFromJson(String str) =>
    List<SubcategoryListModel>.from(
        json.decode(str).map((x) => SubcategoryListModel.fromJson(x)));

String subcategoryListModelToJson(List<SubcategoryListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubcategoryListModel {
  int id;
  String description;
  String image;
  dynamic name;
  int isStatic;
  List<AddOn> addOns;
  List<dynamic> subjectList;
  CategoryDetails? categoryDetails;

  SubcategoryListModel({
    required this.id,
    required this.description,
    required this.image,
    required this.name,
    required this.isStatic,
    required this.addOns,
    required this.subjectList,
    this.categoryDetails,
  });

  factory SubcategoryListModel.fromJson(Map<String, dynamic> json) =>
      SubcategoryListModel(
        id: json["id"],
        description: json["description"],
        image: json["image"],
        name: json["name"],
        isStatic: json["is_static"],
        addOns: List<AddOn>.from(json["add_ons"].map((x) => AddOn.fromJson(x))),
        subjectList: List<dynamic>.from(json["subject_list"].map((x) => x)),
        categoryDetails: json["category_details"] == null
            ? null
            : CategoryDetails.fromJson(json["category_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "name": name,
        "is_static": isStatic,
        "add_ons": List<dynamic>.from(addOns.map((x) => x.toJson())),
        "subject_list": List<dynamic>.from(subjectList.map((x) => x)),
        "category_details": categoryDetails?.toJson(),
      };
}

class AddOn {
  int id;
  int isPrice;
  int price;
  dynamic name;

  AddOn({
    required this.id,
    required this.isPrice,
    required this.price,
    required this.name,
  });

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
        id: json["id"],
        isPrice: json["is_price"],
        price: json["price"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_price": isPrice,
        "price": price,
        "name": name,
      };
}

class CategoryDetails {
  int id;
  String name;
  String description;
  String tag;
  String image;
  dynamic title;

  CategoryDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.tag,
    required this.image,
    required this.title,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
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
