import 'package:injectable/injectable.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/usecases/get_top_products_usecase.dart';

@injectable
class TopProductsCubit extends LoadDataBaseCubit<List<Product>> {
  final GetTopProductsUseCase _getTopProductsUseCase;

  TopProductsCubit(this._getTopProductsUseCase) : super();

  @override
  Future<Resource<List<Product>>> usecaseCall() async {
    return await _getTopProductsUseCase.execute();
  }

  void refreshProducts() {
    refresh(isSilent: true);
  }
}
