import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_ecatalog/data/models/request/update_product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/update_product_response_model.dart';
import 'package:http/http.dart' as http;

class UpdateProductDatasource {
  Future<Either<String, UpdateProductResponseModel>> updateProduct(
      UpdateProductRequestModel model, int idProduct) async {
    try {
      final response = await http
          .put(Uri.parse('https://api.escuelajs.co/api/v1/products/$idProduct'))
          .timeout(const Duration(seconds: 20));
      return Right(
          UpdateProductResponseModel.fromJson(jsonDecode(response.body)));
    } catch (error, _) {
      return Left('Gagal');
    }
  }
}
