import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crypto_model.dart';
import '../services/websocket_service.dart';
import '../services/api_service.dart';

final cryptoProvider = StateNotifierProvider<CryptoViewModel, CryptoModel?>((ref) {
  return CryptoViewModel();
});

class CryptoViewModel extends StateNotifier<CryptoModel?> {
  late WebSocketService _webSocketService;
  final ApiService _apiService = ApiService();

  List<double> historicalPrices = [];
  String selectedSymbol = 'bitcoin';
  String selectedTimePeriod = '30';

  CryptoViewModel() : super(null) {
    _webSocketService = WebSocketService('wss://stream.binance.com:9443/ws/btcusdt@trade');
    _webSocketService.connect((crypto) {
      state = crypto;
    });

    fetchHistoricalData();
  }

  void fetchHistoricalData() async {
  try {
    historicalPrices = await _apiService.fetchHistoricalData(selectedSymbol, selectedTimePeriod);
    // Notify UI by calling state = state; (Triggers Riverpod rebuild)
    state = state == null ? null : CryptoModel(symbol: state!.symbol, price: state!.price);
  } catch (e) {
    print("Error fetching historical data: $e");
  }
}

void changeCrypto(String newSymbol) {
  print("Changing Crypto to: $newSymbol");
  selectedSymbol = newSymbol;

  // Binance WebSocket requires specific tickers
  Map<String, String> tickerMap = {
    "bitcoin": "btcusdt",
    "ethereum": "ethusdt",
    "dogecoin": "dogeusdt"
  };

  String correctTicker = tickerMap[newSymbol] ?? "btcusdt"; // Default to BTC if unknown

  // Disconnect previous WebSocket
  _webSocketService.disconnect();
  print("Disconnected WebSocket");

  // Connect to the correct WebSocket URL
  String wsUrl = 'wss://stream.binance.com:9443/ws/$correctTicker@trade';
  print("Connecting to: $wsUrl");

  _webSocketService = WebSocketService(wsUrl);
  _webSocketService.connect((crypto) {
    print("Received Data: ${crypto.symbol} - ${crypto.price}");
    state = crypto; // ✅ Updates the UI with the correct price
  });

  fetchHistoricalData(); // ✅ Updates the graph
}

  void changeTimePeriod(String newPeriod) {
    selectedTimePeriod = newPeriod;
    fetchHistoricalData();
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }
}
