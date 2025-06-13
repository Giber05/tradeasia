import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/usecases/get_top_products_usecase.dart';

@injectable
class TopProductsCubit extends LoadDataBaseCubit<List<Product>> {
  final GetTopProductsUseCase _getTopProductsUseCase;

  List<Product> _allProducts = [];
  String _currentSearchQuery = '';

  TopProductsCubit(this._getTopProductsUseCase) : super();

  @override
  Future<Resource<List<Product>>> usecaseCall() async {
    final result = await _getTopProductsUseCase.execute();

    // Store all products for search functionality
    if (result is Success<List<Product>>) {
      _allProducts = result.data;
    }

    return result;
  }

  void refreshProducts() {
    refresh(isSilent: true);
  }

  void searchProducts(String query) {
    _currentSearchQuery = query.trim().toLowerCase();

    if (_currentSearchQuery.isEmpty) {
      // Show all products when search is empty
      emit(CubitState.success(data: _allProducts));
    } else {
      // Filter products based on search query
      final filteredProducts =
          _allProducts.where((product) {
            return product.productName.toLowerCase().contains(_currentSearchQuery) ||
                product.casNumber.toLowerCase().contains(_currentSearchQuery) ||
                product.hsCode.toLowerCase().contains(_currentSearchQuery) ||
                product.formula.toLowerCase().contains(_currentSearchQuery) ||
                product.iupacName.toLowerCase().contains(_currentSearchQuery);
          }).toList();

      emit(CubitState.success(data: filteredProducts));
    }
  }

  void clearSearch() {
    _currentSearchQuery = '';
    emit(CubitState.success(data: _allProducts));
  }

  String get currentSearchQuery => _currentSearchQuery;
  bool get isSearchActive => _currentSearchQuery.isNotEmpty;
}
