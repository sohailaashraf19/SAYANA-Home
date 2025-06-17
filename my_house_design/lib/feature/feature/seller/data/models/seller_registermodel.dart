class SellerRegisterModel {
  final String message;
  final String token;
  final SellerData seller;

  SellerRegisterModel({
    required this.message,
    required this.token,
    required this.seller,
  });

  factory SellerRegisterModel.fromJson(Map<String, dynamic> json) {
    return SellerRegisterModel(
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      seller: SellerData.fromJson(json['seller'] ?? {}),
    );
  }
}

class SellerData {
  final int id;
  final String phone;
  final String email;
  final String brandName;

  SellerData({
    required this.id,
    required this.phone,
    required this.email,
    required this.brandName,
  });

  factory SellerData.fromJson(Map<String, dynamic> json) {
    return SellerData(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
    );
  }
}

