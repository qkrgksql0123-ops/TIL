import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/model/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<ProductModel?> newlyAddedProduct = Rx<ProductModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadFakeProducts();
  }

  void _loadFakeProducts() {
    final fakeProducts = [
      ProductModel(
        id: '1',
        title: '자전거 팝니다',
        description: '거의 새것, 1년 사용했습니다. 상태 좋아요!',
        price: '150,000',
        isShare: false,
        category: ProductCategoryType.sports,
        tradeLocation: '강남역 2번 출구',
        assetImages: ['assets/images/bike.jpg'],
        createdAt: DateTime(2025, 12, 7),
        sellerName: '김민수',
      ),
      ProductModel(
        id: '2',
        title: '사과 한 박스',
        description: '시골에서 직접 재배한 꿀사과입니다. 당도 최고!',
        price: '25,000',
        isShare: false,
        category: ProductCategoryType.processedFood,
        tradeLocation: '홍대입구역',
        assetImages: ['assets/images/appl.jpg'],
        createdAt: DateTime(2025, 12, 6),
        sellerName: '이영희',
      ),
      ProductModel(
        id: '3',
        title: '바나나 나눔합니다',
        description: '너무 많이 사서 나눔해요~ 선착순!',
        price: '',
        isShare: true,
        category: ProductCategoryType.processedFood,
        tradeLocation: '신촌역 3번 출구',
        assetImages: ['assets/images/banana.jpg'],
        createdAt: DateTime(2025, 12, 5),
        sellerName: '최준호',
      ),
      ProductModel(
        id: '4',
        title: '무화과 판매',
        description: '신선한 무화과 팔아요. 직거래만 가능합니다.',
        price: '18,000',
        isShare: false,
        category: ProductCategoryType.processedFood,
        tradeLocation: '잠실역',
        assetImages: ['assets/images/fig.jpg'],
        createdAt: DateTime(2025, 12, 4),
        sellerName: '정수진',
      ),
    ];

    products.addAll(fakeProducts);
  }

  Future<void> addProduct(ProductModel product) async {
    isLoading.value = true;
    newlyAddedProduct.value = product;

    // 로딩 시뮬레이션 (실제로는 서버 업로드)
    await Future.delayed(const Duration(seconds: 2));

    products.insert(0, product);
    isLoading.value = false;
    newlyAddedProduct.value = null;
  }

  void clearLoading() {
    isLoading.value = false;
    newlyAddedProduct.value = null;
  }
}
