import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/data/datasources/local_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_ecatalog/presentation/detail_product_page.dart';
import 'package:flutter_ecatalog/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;
  List<ProductResponseModel> products = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    context.read<ProductsBloc>().add(GetProductsEvent(page: page));
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        page = page + 1;
        context.read<ProductsBloc>().add(GetProductsEvent(page: page));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              LocalDataSource().removeToken();
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const LoginPage();
              }));
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            if (page == 1) {
              products = state.data;
            } else {
              products.addAll(state.data);
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // List product
            child: ListView.builder(
              controller: controller,
              // reverse: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailProductPage(
                        productId: products[index].id ?? 0,
                      );
                    }))
                  },
                  child: Card(
                    child: ListTile(
                      title:
                          Text(products[index].title ?? '-'),
                      subtitle: Text('${products[index].price}\$'),
                    ),
                  ),
                );
              },
              itemCount: products.length,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Add Product Success')),
                          );
                          page = 0;
                          context
                              .read<ProductsBloc>()
                              .add(GetProductsEvent(page: page));
                          titleController!.clear();
                          priceController!.clear();
                          descriptionController!.clear();
                          Navigator.pop(context);
                        }
                        if (state is AddProductError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Add Product ${state.message}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                            onPressed: () {
                              final model = ProductRequestModel(
                                title: titleController!.text,
                                price: int.parse(priceController!.text),
                                description: descriptionController!.text,
                              );

                              context
                                  .read<AddProductBloc>()
                                  .add(DoAddProductEvent(model: model));
                            },
                            child: const Text('Add'));
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
