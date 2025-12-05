import 'dart:io';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:bamtol_market_app/src/common/controller/product_controller.dart';
import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/common/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductWritePage extends StatefulWidget {
  const ProductWritePage({super.key});

  @override
  State<ProductWritePage> createState() => _ProductWritePageState();
}

class _ProductWritePageState extends State<ProductWritePage> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  final int _maxImages = 10;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isShareEnabled = false;
  ProductCategoryType _selectedCategory = ProductCategoryType.none;
  String? _tradeLocation;

  Future<void> _pickImage() async {
    if (_images.length >= _maxImages) {
      Get.snackbar(
        '알림',
        '최대 $_maxImages장까지 등록할 수 있습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 카메라 버튼
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined,
                        color: Colors.grey, size: 30),
                    const SizedBox(height: 4),
                    AppFont(
                      '${_images.length}/$_maxImages',
                      size: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 이미지 리스트
            ..._images.asMap().entries.map((entry) {
              int index = entry.key;
              XFile image = entry.value;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: kIsWeb
                          ? Image.network(
                              image.path,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(image.path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: -5,
                      right: -5,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return GestureDetector(
      onTap: () async {
        if (title == '거래 희망 장소') {
          final result = await Get.toNamed('/product/trade-location');
          if (result != null) {
            setState(() {
              _tradeLocation = result as String;
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppFont(
              title == '거래 희망 장소' && _tradeLocation != null
                  ? _tradeLocation!
                  : title,
              color: title == '거래 희망 장소' && _tradeLocation != null
                  ? Colors.white
                  : Colors.grey,
              size: 16,
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GestureDetector(
      onTap: _showCategorySelector,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppFont(
              _selectedCategory.name,
              color: _selectedCategory == ProductCategoryType.none
                  ? Colors.grey
                  : Colors.white,
              size: 16,
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff212123),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // 핸들바
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppFont(
                    '카테고리 선택',
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: ProductCategoryType.values.length - 1, // none 제외
                    itemBuilder: (context, index) {
                      final category =
                          ProductCategoryType.values[index + 1]; // none 건너뛰기
                      return ListTile(
                        title: AppFont(
                          category.name,
                          color: _selectedCategory == category
                              ? Colors.orange
                              : Colors.white,
                        ),
                        trailing: _selectedCategory == category
                            ? const Icon(Icons.check, color: Colors.orange)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTitleInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _titleController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: '글 제목',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '₩ 가격을 입력해주세요.',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          // 나눔 체크박스
          GestureDetector(
            onTap: () {
              setState(() {
                _isShareEnabled = !_isShareEnabled;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _isShareEnabled ? Colors.orange : Colors.transparent,
                    border: Border.all(
                      color: _isShareEnabled ? Colors.orange : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _isShareEnabled
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
                const SizedBox(width: 8),
                const AppFont('나눔', color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _descriptionController,
        style: const TextStyle(color: Colors.white),
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: '올릴 게시글 내용을 작성해 주세요.\n(판매 금지 물품은 게시가 제한될 수 있어요.)',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const AppFont(
          '내 물건 팔기',
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 선택 영역
                  _buildImageSection(),
                  const Divider(color: Colors.grey, height: 1),

                  // 카테고리 선택
                  _buildCategorySelector(),
                  const Divider(color: Colors.grey, height: 1),

                  // 제목 입력
                  _buildTitleInput(),
                  const Divider(color: Colors.grey, height: 1),

                  // 가격 입력
                  _buildPriceInput(),
                  const Divider(color: Colors.grey, height: 1),

                  // 설명 입력
                  _buildDescriptionInput(),
                  const Divider(color: Colors.grey, height: 1),

                  // 거래 희망 장소
                  _buildMenuItem('거래 희망 장소'),
                  const Divider(color: Colors.grey, height: 1),
                ],
              ),
            ),
          ),
          // 등록하기 버튼
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Btn(
              onTap: _registerProduct,
              child: const Center(
                child: AppFont(
                  '등록하기',
                  fontWeight: FontWeight.bold,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerProduct() {
    // 상품 모델 생성
    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.isEmpty ? '제목 없음' : _titleController.text,
      description: _descriptionController.text,
      price: _priceController.text,
      isShare: _isShareEnabled,
      category: _selectedCategory,
      tradeLocation: _tradeLocation,
      images: List.from(_images),
      createdAt: DateTime.now(),
    );

    // 알림창 표시
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: const Text('물건이 등록되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              // ProductController에 상품 추가 및 홈으로 이동
              ProductController.to.addProduct(product);
              Get.offAllNamed('/home');
            },
            child: const Text(
              '확인',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
