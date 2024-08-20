class TickerData {
  final String type;
  final String symbol;
  final int priceChange;
  final int priceChangePercent;
  final int currentPrice;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int bestBidPrice;
  final int bestAskPrice;

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
      priceChange: json['p'],
      priceChangePercent: json['P'],
      currentPrice: json['c'],
      openPrice: json['o'],
      highPrice: json['h'],
      lowPrice: json['l'],
      bestBidPrice: json['b'],
      bestAskPrice: json['a'],
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
