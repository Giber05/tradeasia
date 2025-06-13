import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';
import 'package:trade_asia/infrastructure/types/exception/server_exception.dart';
import 'package:trade_asia/infrastructure/types/exception/connection_exception.dart';
import 'package:trade_asia/modules/product/domain/entities/product_detail.dart';
import 'package:trade_asia/modules/product/domain/repositories/product_repository.dart';
import 'package:trade_asia/modules/product/domain/usecases/get_product_details_usecase.dart';

import 'get_product_details_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProductDetailsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductDetailsUseCase(mockRepository);
  });

  group('GetProductDetailsUseCase', () {
    const testProductId = '123';
    const testProductDetail = ProductDetail(
      productImage: 'https://test.com/image.jpg',
      productName: 'Test Product Detail',
      iupacName: 'Test IUPAC',
      casNumber: '123-45-6',
      hsCode: 'HS001',
      formula: 'H2O',
      tdsFile: 'test_tds.pdf',
      msdsFile: 'test_msds.pdf',
      description: 'Test Description',
      application: 'Test Application Detail',
      commonNames: 'Test Common Names',
      productIndustries: [
        ProductIndustry(
          id: 1,
          prodindName: 'Test Industry',
          prodindDesc: 'Test Industry Description',
          prodindUrl: 'https://test.com/industry',
        ),
      ],
      prodindName: 'Test Product Industry Name',
      categoryName: 'Test Category Name',
      relatedProducts: [],
      basicInfo: BasicInfo(
        phyAppearName: 'Test Appearance',
        packagingName: 'Test Packaging',
        commonNames: 'Test Common Names',
      ),
    );

    test('should return Success with product details when repository call is successful', () async {
      // Arrange
      when(mockRepository.getProductDetails(testProductId)).thenAnswer((_) async => testProductDetail);

      // Act
      final result = await useCase(testProductId);

      // Assert
      expect(result, isA<Success<ProductDetail>>());
      expect((result as Success<ProductDetail>).data, equals(testProductDetail));
      verify(mockRepository.getProductDetails(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error when repository throws ServerException', () async {
      // Arrange
      const exception = ServerException(message: 'Product not found', statusCode: 404);
      when(mockRepository.getProductDetails(testProductId)).thenThrow(exception);

      // Act
      final result = await useCase(testProductId);

      // Assert
      expect(result, isA<Error<ProductDetail>>());
      expect((result as Error<ProductDetail>).exception, equals(exception));
      verify(mockRepository.getProductDetails(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error when repository throws ConnectionException', () async {
      // Arrange
      const exception = ConnectionException(message: 'No internet connection');
      when(mockRepository.getProductDetails(testProductId)).thenThrow(exception);

      // Act
      final result = await useCase(testProductId);

      // Assert
      expect(result, isA<Error<ProductDetail>>());
      expect((result as Error<ProductDetail>).exception, equals(exception));
      verify(mockRepository.getProductDetails(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Error with BaseException when repository throws unknown exception', () async {
      // Arrange
      when(mockRepository.getProductDetails(testProductId)).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await useCase(testProductId);

      // Assert
      expect(result, isA<Error<ProductDetail>>());
      final errorResult = result as Error<ProductDetail>;
      expect(errorResult.exception.isUnknownError, isTrue);
      verify(mockRepository.getProductDetails(testProductId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct productId to repository', () async {
      // Arrange
      const customProductId = '456';
      when(mockRepository.getProductDetails(customProductId)).thenAnswer((_) async => testProductDetail);

      // Act
      await useCase(customProductId);

      // Assert
      verify(mockRepository.getProductDetails(customProductId)).called(1);
      verifyNever(mockRepository.getProductDetails(testProductId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
