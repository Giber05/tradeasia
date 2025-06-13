import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/infrastructure/types/exception/server_exception.dart';
import 'package:trade_asia/infrastructure/types/exception/connection_exception.dart';
import 'package:trade_asia/modules/product/domain/entities/product.dart';
import 'package:trade_asia/modules/product/domain/repositories/product_repository.dart';
import 'package:trade_asia/modules/product/domain/usecases/get_top_products_usecase.dart';

import 'get_top_products_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetTopProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetTopProductsUseCase(mockRepository);
  });

  group('GetTopProductsUseCase', () {
    const testProducts = [
      Product(
        id: 1,
        productImage: 'https://test.com/image1.jpg',
        productName: 'Test Product 1',
        casNumber: '123-45-6',
        iupacName: 'Test IUPAC 1',
        hsCode: 'HS001',
        formula: 'H2O',
        priority: 1,
      ),
      Product(
        id: 2,
        productImage: 'https://test.com/image2.jpg',
        productName: 'Test Product 2',
        casNumber: '789-01-2',
        iupacName: 'Test IUPAC 2',
        hsCode: 'HS002',
        formula: 'NaCl',
        priority: 2,
      ),
    ];

    test('should return Success with list of products when repository call is successful', () async {
      // Arrange
      when(mockRepository.getTopProducts()).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Success<List<Product>>>());
      expect((result as Success<List<Product>>).data, equals(testProducts));
      verify(mockRepository.getTopProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error when repository throws ServerException', () async {
      // Arrange
      const exception = ServerException(message: 'Server error', statusCode: 500);
      when(mockRepository.getTopProducts()).thenThrow(exception);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Error<List<Product>>>());
      expect((result as Error<List<Product>>).exception, equals(exception));
      verify(mockRepository.getTopProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error when repository throws ConnectionException', () async {
      // Arrange
      const exception = ConnectionException(message: 'No internet connection');
      when(mockRepository.getTopProducts()).thenThrow(exception);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Error<List<Product>>>());
      expect((result as Error<List<Product>>).exception, equals(exception));
      verify(mockRepository.getTopProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Success with empty list when repository returns empty data', () async {
      // Arrange
      when(mockRepository.getTopProducts()).thenAnswer((_) async => <Product>[]);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Success<List<Product>>>());
      expect((result as Success<List<Product>>).data, isEmpty);
      verify(mockRepository.getTopProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error with BaseException when repository throws unknown exception', () async {
      // Arrange
      when(mockRepository.getTopProducts()).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Error<List<Product>>>());
      final errorResult = result as Error<List<Product>>;
      expect(errorResult.exception.isUnknownError, isTrue);
      verify(mockRepository.getTopProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
