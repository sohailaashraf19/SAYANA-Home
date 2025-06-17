class HighestSpendingCustomer {
  final String name;
  final int totalOrders;

  HighestSpendingCustomer({
    required this.name,
    required this.totalOrders,
  });

  factory HighestSpendingCustomer.fromJson(Map<String, dynamic> json) {
    return HighestSpendingCustomer(
      name: json['name'],
      totalOrders: json['total_orders'],
    );
  }
}
