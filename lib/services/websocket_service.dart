import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import '../models/crypto_model.dart';
import '../services/notification_service.dart';

class WebSocketService {
  final String url;
  late IOWebSocketChannel _channel;
  double? previousPrice;

  WebSocketService(this.url);

  void connect(Function(CryptoModel) onData) {
    _channel = IOWebSocketChannel.connect(url);
    _channel.stream.listen((event) {
      final data = jsonDecode(event);
      final crypto = CryptoModel.fromJson(data);
      _sendTestNotification(crypto.symbol, crypto.price);
      
      previousPrice = crypto.price; // ✅ Update stored price
      onData(crypto);
    });
  }

  void disconnect() {
    _channel.sink.close();
  }

    void _sendTestNotification(String symbol, double price) {
    NotificationService.showNotification(
      "Test Crypto Alert 🚀",
      "$symbol price update: \$$price"
    );
  }
}

