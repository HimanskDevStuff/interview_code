import 'package:interview_code/data/model/ProductResponse.dart';

abstract class ProductRepository {
  Future<List<ProductResponse>> getProducts();
}