class TopSellingProduct {
  final int productId;
  final String name;
  final String imageUrl;
  final String totalSold;

  TopSellingProduct({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.totalSold,
  });

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    // Construct the full image URL from image_path
    String baseUrl = "https://olivedrab-llama-457480.hostingersite.com/";
    String rawImagePath = json['image_path'] ?? '';
    String fullImageUrl = Uri.encodeFull("$baseUrl$rawImagePath");

    return TopSellingProduct(
      productId: json['product_id'],
      name: json['name'],
      totalSold: json['total_sold'],
      imageUrl: fullImageUrl,
    );
  }
}
