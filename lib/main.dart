import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/detail_product/detail_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/bloc/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/cubit/login_cubit.dart';
import 'package:flutter_ecatalog/data/datasources/auth_datasource.dart';
import 'package:flutter_ecatalog/data/datasources/detail_product_datasource.dart';
import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/datasources/update_product_datasource.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/register/register_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthDatasource()),
        ),
        BlocProvider(create: (context) => LoginBloc(AuthDatasource())),
        BlocProvider(
          create: (context) => ProductsBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => DetailProductBloc(DetailProductDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateProductBloc(UpdateProductDatasource()),
        ),
        BlocProvider(create: (context) => LoginCubit(AuthDatasource()))
      ],
      child: MaterialApp(
        title: 'Flutter Catalog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 121, 78, 195)),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
