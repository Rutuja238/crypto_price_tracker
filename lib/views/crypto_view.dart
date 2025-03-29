import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/crypto_viewmodel.dart';

class CryptoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crypto = ref.watch(cryptoProvider);
    final cryptoViewModel = ref.read(cryptoProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Crypto Price Tracker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: cryptoViewModel.selectedSymbol,
              items: [
                DropdownMenuItem(value: "bitcoin", child: Text("Bitcoin (BTC)")),
                DropdownMenuItem(value: "ethereum", child: Text("Ethereum (ETH)")),
                DropdownMenuItem(value: "dogecoin", child: Text("Dogecoin (DOGE)")),
              ],
              onChanged: (value) {
                cryptoViewModel.changeCrypto(value!);
              },
            ),
            SizedBox(height: 20),
            crypto == null
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        "${crypto.symbol.toUpperCase()}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${crypto.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 40, color: Colors.green),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Text("Price Trend"),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        cryptoViewModel.historicalPrices.length,
                        (index) => FlSpot(index.toDouble(), cryptoViewModel.historicalPrices[index]),
                      ),
                      isCurved: true,
                      // colors: [Colors.blue],
                    ),
                  ],
                ),
              ),
            ),
            DropdownButton<String>(
              value: cryptoViewModel.selectedTimePeriod,
              items: [
                DropdownMenuItem(value: "30", child: Text("1 Month")),
                DropdownMenuItem(value: "180", child: Text("6 Months")),
                DropdownMenuItem(value: "365", child: Text("1 Year")),
              ],
              onChanged: (value) {
                cryptoViewModel.changeTimePeriod(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
