class OrdersCountModel {
  final int totalOrdersParticipatedIn;

  OrdersCountModel({required this.totalOrdersParticipatedIn});

  factory OrdersCountModel.fromJson(Map<String, dynamic> json) {
    return OrdersCountModel(
      totalOrdersParticipatedIn: json['total_orders_participated_in'] ?? 0,
    );
  }
}
