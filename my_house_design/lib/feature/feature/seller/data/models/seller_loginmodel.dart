class SellerLoginModel {
  final String message;
  final String token;
  final Seller seller;

  SellerLoginModel({
    required this.message,
    required this.token,
    required this.seller,
  });

  factory SellerLoginModel.fromJson(Map<String, dynamic> json) {
    return SellerLoginModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      seller: json['seller'] != null
          ? Seller.fromJson(json['seller'])
          : Seller.empty(),
    );
  }
}

class Seller {
  final int sellerId;
  final String brandname;
  final String email;
  final String phone;

  Seller({
    required this.sellerId,
    required this.brandname,
    required this.email,
    required this.phone,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      sellerId: json['seller_id'] ?? 0,
      brandname: json['brand_name'] ?? '', 
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  factory Seller.empty() {
    return Seller(
      sellerId: 0,
      brandname: '',
      email: '',
      phone: '',
    );
  }
}
