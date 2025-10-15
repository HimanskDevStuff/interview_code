
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_code/data/model/ProductResponse.dart';
import 'package:interview_code/presentation/bloc/ProductBloc.dart';
import 'package:interview_code/presentation/bloc/ProductEvents.dart';
import 'package:interview_code/presentation/bloc/ProductState.dart';

import '../../main.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}


class _ProductsScreenState extends State<ProductsScreen> {
  String searchText = '';
  late ProductBlock bloc ;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<ProductBlock>();
    bloc.add(LoadProductEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ProductBlock>().add(LoadProductEvents());
          },
          child: Icon(Icons.refresh),
        ),
        appBar: AppBar(title: Text('Products'), backgroundColor: Colors.blue),
        body: BlocBuilder<ProductBlock, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                var data = state as ProductLoaded;
               return _bodySearch(data.products);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        )
    );
  }

  Widget _bodySearch(List<ProductResponse> products) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              // Filter products based on search
              if (searchText.isNotEmpty &&
                  !product.title.toString().toLowerCase().contains(
                    searchText.toLowerCase(),
                  )) {
                return Container();
              }

              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          product.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                Text(
                                  ' ${product.rating?.rate ?? 0.0} (${product.rating?.count })',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

