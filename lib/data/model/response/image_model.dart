// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  String originalname;
  String filename;
  String location;

  ImageModel({
    required this.originalname,
    required this.filename,
    required this.location,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        originalname: json["originalname"],
        filename: json["filename"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "originalname": originalname,
        "filename": filename,
        "location": location,
      };
}
