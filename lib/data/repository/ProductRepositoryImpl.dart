import 'package:interview_code/data/model/ProductResponse.dart';
import 'package:interview_code/data/remote/ApiService.dart';
import 'package:interview_code/domain/repository/ProductRepository.dart';

class ProductRepositoryImpl implements ProductRepository{

  final ApiService _apiService;

  ProductRepositoryImpl(this._apiService);

  @override
  Future<List<ProductResponse>> getProducts() async {
    final response = await _apiService.getProducts();
    print("resss: inImpl $response");
    return response;
  }

}