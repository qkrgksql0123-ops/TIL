import 'dart:io';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/controller/product_controller.dart';
import 'package:bamtol_market_app/src/common/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentLocation = '덕풍동';
  final List<String> _locations = ['미사2동', '고덕동'];

  void _showLocationMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        20,
        offset.dy + button.size.height + 10,
        overlay.size.width - 200,
        0,
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      items: <PopupMenuEntry<String>>[
        ..._locations.map((location) => PopupMenuItem<String>(
              value: location,
              height: 50,
              child: AppFont(
                location,
                color:
                    location == _currentLocation ? Colors.black : Colors.grey,
                fontWeight: location == _currentLocation
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            )),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          height: 50,
          child: const AppFont(
            '내 동네 설정',
            color: Colors.grey,
          ),
        ),
      ],
    ).then((value) {
      if (value != null && value != 'settings') {
        setState(() {
          _currentLocation = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => GestureDetector(
            onTap: () => _showLocationMenu(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppFont(
                  _currentLocation,
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        final productController = ProductController.to;
        final isLoading = productController.isLoading.value;
        final products = productController.products;
        final newProduct = productController.newlyAddedProduct.value;

        return Stack(
          children: [
            products.isEmpty
                ? const Center(
                    child: AppFont(
                      '등록된 상품이 없습니다.',
                      color: Colors.grey,
                      size: 16,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      height: 32,
                    ),
                    itemBuilder: (context, index) {
                      return _buildRegisteredProductItem(products[index]);
                    },
                  ),
            // 로딩 오버레이
            if (isLoading && newProduct != null)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      const AppFont(
                        '로딩중...',
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildRegisteredProductItem(ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상품 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: product.images.isNotEmpty
              ? (kIsWeb
                  ? Image.network(
                      product.images.first.path,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(product.images.first.path),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ))
              : Image.asset(
                  'assets/images/logo_simbol.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 16),
        // 상품 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFont(
                product.title,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 4),
              AppFont(
                '${product.sellerName} · ${product.formattedDate}',
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  AppFont(
                    product.displayPrice,
                    size: 14,
                    color: product.isShare ? Colors.orange : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  if (product.isShare) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.favorite,
                      color: Colors.orange.shade300,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
