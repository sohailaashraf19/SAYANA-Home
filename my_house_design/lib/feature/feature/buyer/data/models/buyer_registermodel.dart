class BuyerRegisterModel {
  final String message;
  final String token;
  final BuyerData buyer;

  BuyerRegisterModel({
    required this.message,
    required this.token,
    required this.buyer,
  });

  factory BuyerRegisterModel.fromJson(Map<String, dynamic> json) {
    return BuyerRegisterModel(
        message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      buyer: BuyerData.fromJson(json['buyer'] ?? {}),
    );
  }
}

class BuyerData {
  final int id;
  final String phone;
  final String email;

  BuyerData({
    required this.id,
    required this.phone,
    required this.email,
  });

  factory BuyerData.fromJson(Map<String, dynamic> json) {
    return BuyerData(
     id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
