class RevenueModel {
  final String sallerId;
  final double totalSalesBeforeFees;
  final double netProfit95Percent;
  final String totalProductsSold;
  final int numberOfOrdersParticipatedIn;

  RevenueModel({
    required this.sallerId,
    required this.totalSalesBeforeFees,
    required this.netProfit95Percent,
    required this.totalProductsSold,
    required this.numberOfOrdersParticipatedIn,
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      sallerId: json['saller_id'] ?? '',
      totalSalesBeforeFees: (json['total_sales_before_fees'] ?? 0).toDouble(),
      netProfit95Percent: (json['net_profit_95_percent'] ?? 0).toDouble(),
      totalProductsSold: json['total_products_sold'] ?? '0',
      numberOfOrdersParticipatedIn: json['number_of_orders_participated_in'] ?? 0,
    );
  }
}
