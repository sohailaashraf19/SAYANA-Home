class ProductCountModel {
  final String sallerId;
  final int productCount;

  ProductCountModel({required this.sallerId, required this.productCount});

  factory ProductCountModel.fromJson(Map<String, dynamic> json) {
    return ProductCountModel(
      sallerId: json['saller_id'].toString(),
      productCount: json['product_count'],
    );
  }
}
