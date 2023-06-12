part of 'detail_product_bloc.dart';

@immutable
abstract class DetailProductState {}

class DetailProductInitial extends DetailProductState {}

class DetailProductLoading extends DetailProductState {}

class DetailProductLoaded extends DetailProductState {
  final ProductDetailResponseModel model;
  DetailProductLoaded({
    required this.model,
  });
}

class DetailProductError extends DetailProductState {
  final String message;
  DetailProductError({
    required this.message,
  });
}
