import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_ecatalog/data/models/response/product_detail_response_model.dart';
import 'package:http/http.dart' as http;

class DetailProductDatasource {
  Future<Either<String, ProductDetailResponseModel>> getDetailProduct(
      int idProduct) async {
    try {
      final response = await http
          .get(Uri.parse('https://api.escuelajs.co/api/v1/products/$idProduct'))
          .timeout(const Duration(seconds: 20));
      return Right(
          ProductDetailResponseModel.fromJson(jsonDecode(response.body)));
    } catch (error, _) {
      return Left('Gagal');
    }
  }
}
