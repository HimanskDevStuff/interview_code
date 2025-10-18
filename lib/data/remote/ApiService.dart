import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interview_code/data/model/ProductResponse.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<ProductResponse>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    try{
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print("jsonList $jsonList");
        var productResponse = jsonList.map((json) => ProductResponse.fromJson(json)).toList();
        return productResponse;
      } else {
        throw Exception('Failed to load products');
      }
    }catch(e){
      print("exception $e");
    }

    return [];

  }
}