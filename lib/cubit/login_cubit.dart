import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/auth_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/login_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/login_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthDatasource authDatasource;
  LoginCubit(
    this.authDatasource,
  ) : super(const _Initial());

  void doLogin(LoginRequestModel model) async {
    emit(const _Loading());
    final service = await authDatasource.loginx(model);
    service.fold(
      (l) {
        emit(_Error(l));
      },
      (r) => emit(_Success(r)),
    );
  }
}
