import 'package:dio/dio.dart';
import 'package:my_house_design/feature/feature/seller/data/models/product_count_model.dart';
import 'package:my_house_design/feature/feature/seller/data/models/revenue_model.dart';
import 'package:my_house_design/feature/feature/seller/data/models/sellerOrders_Model.dart';
import 'package:my_house_design/feature/feature/seller/data/models/uniquebuyers_model.dart';

/// Remote‑data source for seller dashboard summary figures.
///
/// * Relies on a single injected [Dio] so higher‑level layers (e.g. an
///   interceptor adding auth tokens) stay in control.
/// * All endpoints share identical error handling via [_wrap].
/// * Guards against Laravelʼs HTML error pages by validating that the payload
///   is JSON before parsing.
class SummaryRemoteDataSource {
  final Dio _dio;

  SummaryRemoteDataSource(this._dio) {
    // Ensure we have the correct base URL and reasonable time‑outs.
    _dio.options = _dio.options.copyWith(
      baseUrl: 'https://olivedrab-llama-457480.hostingersite.com/public/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );

    // Attach a logger only once.
    final hasLogger = _dio.interceptors.any((i) => i is LogInterceptor);
    if (!hasLogger) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj),
      ));
    }
  }

  /* ───────────────────────────── API methods ───────────────────────────── */

  Future<UniqueBuyersModel> fetchUniqueBuyers(int sellerId) => _wrap(
        () => _dio.get('/sellerunique-buyers/$sellerId'),
        UniqueBuyersModel.fromJson,
      );

  Future<OrdersCountModel> fetchOrdersCount(int sellerId) => _wrap(
        () => _dio.get('/sellerorders-count/$sellerId'),
        OrdersCountModel.fromJson,
      );

  Future<RevenueModel> fetchRevenue(int sellerId) => _wrap(
        () => _dio.get('/sellerrevenue/$sellerId'),
        RevenueModel.fromJson,
      );

  Future<ProductCountModel> fetchProductCount(int sellerId) => _wrap(
        () => _dio.get(
          '/sellercount-products',
          // ❗ The backend currently expects the typo `saller_id`.
          queryParameters: {'saller_id': sellerId},
        ),
        ProductCountModel.fromJson,
      );

  /* ───────────────────────────── helper ───────────────────────────── */

  /// Wraps each network call, checks for HTML payloads (Laravel crash pages),
  /// and parses JSON into the provided model.
  Future<T> _wrap<T>(
    Future<Response<dynamic>> Function() requestFn,
    T Function(Map<String, dynamic>) parser,
  ) async {
    try {
      final resp = await requestFn();

      // If we accidentally got an HTML error page, surface a clear message.
      if (resp.data is String &&
          (resp.data as String).startsWith('<!DOCTYPE html>')) {
        throw DioException(
          requestOptions: resp.requestOptions,
          response: resp,
          type: DioExceptionType.badResponse,
          error: 'HTML error page received – probable server crash.',
        );
      }

      return parser(resp.data as Map<String, dynamic>);
    } on DioException {
      rethrow; // Let higher layers decide what to do with network errors.
    } catch (e, s) {
      throw StateError('Failed to parse response → $e\n$s');
    }
  }
}
