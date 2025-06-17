class ProductModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final int categoryId;
  final int salesCount;
  final int sellerId;
  final String color;
  final String type;
  final int discount;
  final String imageUrl;
  

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.salesCount,
    required this.sellerId,
    required this.color,
    required this.type,
    required this.discount,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String getFirstImageUrl() {
      final images = json['images'];
      if (images != null && images is List && images.isNotEmpty) {
        final firstImage = images[0];
        if (firstImage != null && firstImage['image_path'] != null) {
         return Uri.encodeFull("https://olivedrab-llama-457480.hostingersite.com/${firstImage['image_path']}");


        }
      }
      return '';
    }

    return ProductModel(
      id: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      categoryId: json['category_id'] ?? 0,
      salesCount: json['sales_count'] ?? 0,
      sellerId: json['saller_id'] ?? 0,
      color: json['color'] ?? '',
      type: json['type'] ?? '',
      discount: json['discount'] ?? 0,
      imageUrl: getFirstImageUrl(),
    );
  }
}
