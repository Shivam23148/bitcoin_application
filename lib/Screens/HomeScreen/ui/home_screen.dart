import 'package:bitcoin_application/Models/ticker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bitcoin_application/Service/websocket_service.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_bloc.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_event.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  final TextEditingController searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc(WebSocketService())..add(WebSocketConnection());
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTickerList(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: const Text("Coins", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: searchQueryController,
        onChanged: (value) => homeBloc.add(SearchCoinsEvent(value)),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.black,
              width: 2,
            ),
          ),
          suffixIcon: const Icon(Icons.search),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTickerList() {
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          if (state is TickerLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (state is TickerDataLoaded) {
            return _buildRefreshableTickerList(state);
          } else if (state is TickerError) {
            return Center(child: Text("Error: ${state.Error}"));
          }
          return const Center(child: Text("Unexpected state"));
        },
      ),
    );
  }

  Widget _buildRefreshableTickerList(TickerDataLoaded state) {
    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      onRefresh: () async {
        homeBloc.add(WebSocketConnection());
      },
      child: state.tickers.isEmpty
          ? const Center(child: Text("No such coin present"))
          : ListView.builder(
              itemCount: state.tickers.length,
              itemBuilder: (context, index) {
                final ticker = state.tickers[index];
                return _buildTickerTile(ticker, index);
              },
            ),
    );
  }

  Widget _buildTickerTile(TickerData ticker, int index) {
    return ListTile(
      tileColor: index.isEven ? Colors.grey.shade100 : Colors.white,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Text(ticker.symbol.substring(0, 1)),
      ),
      title: Text(ticker.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: _buildTrailing(ticker),
    );
  }

  Widget _buildTrailing(TickerData ticker) {
    final priceChange = double.parse(ticker.priceChangePercent);
    final priceChangeColor = priceChange > 0 ? Colors.green : Colors.red;
    final priceChangeIcon = priceChange > 0
        ? Icons.arrow_upward_outlined
        : Icons.arrow_downward_outlined;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "₹ ${ticker.currentPrice}",
          textScaleFactor: 1.0,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 10),
        Container(
          height: 25,
          width: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(priceChangeIcon, size: 12, color: priceChangeColor),
              Text(
                priceChange.abs().toStringAsFixed(2),
                textScaleFactor: 1.0,
                style: TextStyle(color: priceChangeColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
