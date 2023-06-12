part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetProductsEvent extends ProductsEvent {
    final int page;
  GetProductsEvent({
    required this.page,
  });
}
