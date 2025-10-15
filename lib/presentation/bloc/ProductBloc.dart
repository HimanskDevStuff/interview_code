import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_code/domain/usecase/ProductUseCase.dart';
import 'package:interview_code/presentation/bloc/ProductEvents.dart';
import 'package:interview_code/presentation/bloc/ProductState.dart';


class ProductBlock extends Bloc<ProductEvents, ProductState>{
  final ProductUseCase productUseCase;
  ProductBlock({required this.productUseCase}) : super(ProductInitial()){
    on<LoadProductEvents> (_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProductEvents event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try{
      final products = await productUseCase.getProducts();
      print("ProductBlock: $products");
      emit(ProductLoaded(products: products));
    }catch(e){
      emit(ProductError(e.toString()));
    }
  }

}