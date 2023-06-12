import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasources/detail_product_datasource.dart';
import 'package:meta/meta.dart';

import '../../data/models/response/product_detail_response_model.dart';

part 'detail_product_event.dart';
part 'detail_product_state.dart';

class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final DetailProductDatasource datasource;
  DetailProductBloc(this.datasource)
      : super(DetailProductInitial()) {
    on<DoDetailProductEvent>((event, emit) async {
      emit(DetailProductLoading());
      final result = await datasource.getDetailProduct(event.productId);
      result.fold((l) => emit(DetailProductError(message: l)),
          (r) => emit(DetailProductLoaded(model: r)));
    });
  }
}
