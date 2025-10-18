import 'package:interview_code/data/model/ProductResponse.dart';
import 'package:interview_code/domain/repository/ProductRepository.dart';

class ProductUseCase{
  final ProductRepository productRepository;

  ProductUseCase({required this.productRepository});

  Future<List<ProductResponse>> getProducts() async {
    return await productRepository.getProducts();
  }
}