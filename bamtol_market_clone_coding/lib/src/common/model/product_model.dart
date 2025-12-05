import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:image_picker/image_picker.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final bool isShare;
  final ProductCategoryType category;
  final String? tradeLocation;
  final List<XFile> images;
  final DateTime createdAt;
  final String sellerName;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isShare,
    required this.category,
    this.tradeLocation,
    required this.images,
    required this.createdAt,
    this.sellerName = '개발하는남자',
  });

  String get formattedDate {
    return '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}';
  }

  String get displayPrice {
    if (isShare) return '나눔';
    if (price.isEmpty) return '가격 미정';
    return '₩$price';
  }
}
