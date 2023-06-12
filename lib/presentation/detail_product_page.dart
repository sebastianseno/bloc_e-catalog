import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/detail_product/detail_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/data/models/request/update_product_request_model.dart';

class DetailProductPage extends StatefulWidget {
  final int productId;

  const DetailProductPage({super.key, required this.productId});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  TextEditingController? descriptionController;
  TextEditingController? priceController;

  @override
  void initState() {
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    context
        .read<DetailProductBloc>()
        .add(DoDetailProductEvent(productId: widget.productId));
    super.initState();
  }

  @override
  void dispose() {
    descriptionController?.dispose();
    priceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<DetailProductBloc, DetailProductState>(
                builder: (context, state) {
                  if (state is DetailProductLoaded) {
                    descriptionController?.text = state.model.description;
                    priceController?.text = state.model.price.toString();
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.network(
                          state.model.images[0],
                          width: double.maxFinite,
                          height: 361,
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: BlocConsumer<UpdateProductBloc,
                              UpdateProductState>(
                            listener: (context, state) {
                              if (state is UpdateProductError) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ));
                              }
                              if (state is UpdateProductLoaded) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Alhamdulillah update berhasil'),
                                  backgroundColor: Colors.blue,
                                  duration: Duration(seconds: 3),
                                ));
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
                                  final updateModel = UpdateProductRequestModel(
                                      images: List.empty(),
                                      price: int.parse(
                                          priceController?.text ?? '0'),
                                      title: descriptionController?.text ?? '');
                                  context.read<UpdateProductBloc>().add(
                                        DoUpdateProductEvent(
                                          model: updateModel,
                                          productId: widget.productId,
                                        ),
                                      );
                                },
                                child: const Text('Submit'),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ));
        },
      ),
    );
  }
}
