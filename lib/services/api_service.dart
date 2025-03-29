import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<double>> fetchHistoricalData(String symbol, String days) async {
    final response = await _dio.get(
      'https://api.coingecko.com/api/v3/coins/$symbol/market_chart',
      queryParameters: {'vs_currency': 'usd', 'days': days},
    );

    return List<double>.from(response.data['prices'].map((p) => p[1]));
  }
}

