import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as context;
import 'package:interview_code/data/remote/ApiService.dart';
import 'package:interview_code/presentation/bloc/ProductBloc.dart';
import 'package:interview_code/presentation/bloc/ProductEvents.dart';
import 'package:interview_code/presentation/bloc/ProductState.dart';
import 'package:interview_code/presentation/screens/ProductScreen.dart';

import 'data/repository/ProductRepositoryImpl.dart';
import 'domain/repository/ProductRepository.dart';
import 'domain/usecase/ProductUseCase.dart';

void main() {
  setUpDependencies();
  runApp(MyApp());
}

void setUpDependencies() {
  var getIt = GetIt.instance;
  getIt.registerSingleton(ApiService());

  getIt.registerSingleton<ProductRepository>(ProductRepositoryImpl(getIt()));

  getIt.registerSingleton<ProductUseCase>(ProductUseCase(productRepository: getIt()));

  getIt.registerSingleton<ProductBlock>(ProductBlock(productUseCase: getIt()));

}

class MyApp extends StatelessWidget {
  var getIt = GetIt.instance;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(title: 'Products List',
        home: MultiBlocProvider(
            providers: [
              BlocProvider<ProductBlock>(
                create: (context) => getIt<ProductBlock>(),
              )
            ],
            child: ProductsScreen()
        )
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                widget.product['image'],
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.product['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${widget.product['price']}',
              style: TextStyle(
                fontSize: 28,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange),
                Text(' ${widget.product['rating']['rate']} '),
                Text('(${widget.product['rating']['count']} reviews)'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Category: ${widget.product['category']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(widget.product['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Quantity: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('Added to Cart'),
                          content: Text(
                            '${widget
                                .product['title']} (Qty: $quantity) added to cart!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Add to Cart - \$${(double.parse(
                      widget.product['price'].toString()) * quantity)
                      .toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
