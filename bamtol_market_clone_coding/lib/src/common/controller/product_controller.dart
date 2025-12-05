import 'package:bamtol_market_app/src/common/model/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<ProductModel?> newlyAddedProduct = Rx<ProductModel?>(null);

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
