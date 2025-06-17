class UniqueBuyersModel {
  final int uniqueBuyersCount;

  UniqueBuyersModel({required this.uniqueBuyersCount});

  factory UniqueBuyersModel.fromJson(Map<String, dynamic> json) {
    return UniqueBuyersModel(
      uniqueBuyersCount: json['unique_buyers_count'],
    );
  }
}
