import 'dart:convert';

import 'package:bitcoin_application/Models/ticker_model.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_event.dart';
import 'package:bitcoin_application/Screens/HomeScreen/bloc/home_state.dart';
import 'package:bitcoin_application/Service/websocket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WebSockerService webSockerService;

  HomeBloc(this.webSockerService) : super(TickerInitial()) {
    on<WebSocketConnection>((event, emit) {
      connectWebSocket(emit);
    });
    on<WebSocketDataRecievedEvent>((event, emit) {
      print("Data recieved is : ${event.data}");
      emit(TickerDataLoaded(List<TickerData>.from(event.data['data'])));
    });
    on<WebSocketErrorEvent>((event, emit) {
      emit(TickerError(event.error));
    });
  }
  void connectWebSocket(Emitter<HomeState> emit) {
    emit(TickerLoading());
    webSockerService.connect('ws://prereg.ex.api.ampiy.com/prices');
    print("Connection made");
    webSockerService.sendMessage({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1
    });
    print("Data send");
    webSockerService.channel.stream.listen(
      (data) {
        final decodedData = jsonDecode(data);
        add(WebSocketDataRecievedEvent(decodedData));
      },
      onError: (error) {
        print("Bloc Error is : $error");
        add(WebSocketErrorEvent(error: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    webSockerService.disconnect();
    return super.close();
  }
}
