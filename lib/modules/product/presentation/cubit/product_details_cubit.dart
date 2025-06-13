import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';
import 'package:trade_asia/modules/product/domain/usecases/get_product_details_usecase.dart';

@injectable
class ProductDetailsCubit extends Cubit<CubitState<ProductDetail>> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailsCubit(this._getProductDetailsUseCase) : super(const CubitState.loading());

  Future<void> loadProductDetails(String productId) async {
    emit(const CubitState.loading());

    final result = await _getProductDetailsUseCase.call(productId);

    switch (result) {
      case Success(data: final productDetail):
        emit(CubitState.success(data: productDetail));
      case Error(exception: final exception):
        emit(CubitState.error(exception: exception, onRetry: () => loadProductDetails(productId)));
    }
  }

  Future<void> refresh(String productId) async {
    final currentState = state;
    if (currentState is CubitSuccessState<ProductDetail>) {
      emit(CubitState.success(data: currentState.data, isRefreshing: true));
    }

    final result = await _getProductDetailsUseCase.call(productId);

    switch (result) {
      case Success(data: final productDetail):
        emit(CubitState.success(data: productDetail));
      case Error(exception: final exception):
        if (currentState is CubitSuccessState<ProductDetail>) {
          // Keep showing old data if refresh fails
          emit(CubitState.success(data: currentState.data));
        } else {
          emit(CubitState.error(exception: exception, onRetry: () => loadProductDetails(productId)));
        }
    }
  }
}
