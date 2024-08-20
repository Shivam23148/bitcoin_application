import 'package:bitcoin_application/Models/ticker_model.dart';

abstract class HomeState {}

class TickerInitial extends HomeState {}

class TickerLoading extends HomeState {}

class TickerDataLoaded extends HomeState {
  final List<TickerData> tickers;

  TickerDataLoaded(this.tickers);
}

class TickerError extends HomeState {
  final String Error;

  TickerError(this.Error);
}
