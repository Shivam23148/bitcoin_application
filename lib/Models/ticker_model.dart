class TickerData {
  final String type;
  final String symbol;
  final String priceChange;
  final String priceChangePercent;
  final String currentPrice;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String bestBidPrice;
  final String bestAskPrice;

  TickerData({
    required this.type,
    required this.symbol,
    required this.priceChange,
    required this.priceChangePercent,
    required this.currentPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.bestBidPrice,
    required this.bestAskPrice,
  });

  factory TickerData.fromJson(Map<String, dynamic> json) {
    return TickerData(
      type: json['T'] as String,
      symbol: json['s'] as String,
      priceChange: json['p'] as String,
      priceChangePercent: json['P'] as String,
      currentPrice: json['c'] as String,
      openPrice: json['o'] as String,
      highPrice: json['h'] as String,
      lowPrice: json['l'] as String,
      bestBidPrice: json['b'] as String,
      bestAskPrice: json['a'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'T': type,
      's': symbol,
      'p': priceChange,
      'P': priceChangePercent,
      'c': currentPrice,
      'o': openPrice,
      'h': highPrice,
      'l': lowPrice,
      'b': bestBidPrice,
      'a': bestAskPrice,
    };
  }
}
