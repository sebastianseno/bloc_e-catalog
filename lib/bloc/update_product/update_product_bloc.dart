import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasources/update_product_datasource.dart';
import 'package:meta/meta.dart';
import 'package:flutter_ecatalog/data/models/response/update_product_response_model.dart';
import 'package:flutter_ecatalog/data/models/request/update_product_request_model.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final UpdateProductDatasource datasource;
  UpdateProductBloc(
    this.datasource,
  ) : super(UpdateProductInitial()) {
    on<DoUpdateProductEvent>((event, emit) async {
      emit(UpdateProductLoading());
      final result =
          await datasource.updateProduct(event.model, event.productId);
      result.fold(
        (l) => emit(UpdateProductError(message: l)),
        (r) => emit(UpdateProductLoaded(model: r)),
      );
    });
  }
}
