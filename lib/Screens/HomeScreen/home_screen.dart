import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_bloc.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_event.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_state.dart';
import 'package:bitcoin_application/Service/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(WebSockerService())..add(WebSocketConnection()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Coins"),
        ),
        body: Column(
          children: [
            SearchBar(),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  print("State is $state");
                  if (state is TickerLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  } else if (state is TickerDataLoaded) {
                    return ListView.builder(
                        itemCount: state.tickers.length,
                        itemBuilder: (context, index) {
                          final ticker = state.tickers[index];
                          return ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(ticker.symbol),
                            subtitle: Text('${ticker.currentPrice}%'),
                            trailing: Text(
                              "${ticker.priceChangePercent}",
                              style: TextStyle(
                                  color: ticker.priceChangePercent > 0
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          );
                        });
                  } else if (state is TickerError) {
                    return Center(
                      child: Text("Error is : ${state.Error}"),
                    );
                  }
                  return Center(
                    child: Text("State is $state"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
