// To parse this JSON data, do
//
//     final updateProductRequestModel = updateProductRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateProductRequestModel updateProductRequestModelFromJson(String str) => UpdateProductRequestModel.fromJson(json.decode(str));

String updateProductRequestModelToJson(UpdateProductRequestModel data) => json.encode(data.toJson());

class UpdateProductRequestModel {
    String title;
    int price;
    List<String> images;

    UpdateProductRequestModel({
        required this.title,
        required this.price,
        required this.images,
    });

    factory UpdateProductRequestModel.fromJson(Map<String, dynamic> json) => UpdateProductRequestModel(
        title: json["title"],
        price: json["price"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}
