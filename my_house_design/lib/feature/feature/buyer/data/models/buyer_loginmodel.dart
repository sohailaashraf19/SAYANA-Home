class BuyerLoginModel {
  final String message;
  final String token;
  final BuyerData buyer;

  BuyerLoginModel({
    required this.message,
    required this.token,
    required this.buyer,
  });

  factory BuyerLoginModel.fromJson(Map<String, dynamic> json) {
    return BuyerLoginModel(
      message: json['message'] ?? 'No message',  // Default to 'No message' if absent
      token: json['token'] ?? '',  // Default to an empty string if no token is found
      buyer: BuyerData.fromJson(json['buyer']),
    );
  }
}

class BuyerData {
  final int id;
  final String email;
  final String name;

  BuyerData({
    required this.id,
    required this.email,
    required this.name,
  });

  factory BuyerData.fromJson(Map<String, dynamic> json) {
    return BuyerData(
      id: int.tryParse(json['buyer_id'].toString()) ?? 0,  // Fallback to 0 if buyer_id is invalid or absent
      email: json['email'] ?? '',  // Default to an empty string if email is absent
      name: json['name'] ?? '',  // Default to an empty string if name is absent
    );
  }
}
