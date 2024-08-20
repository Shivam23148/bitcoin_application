abstract class HomeEvent {}

class WebSocketConnection extends HomeEvent {}

class WebSocketDataRecievedEvent extends HomeEvent {
  final Map<String, dynamic> data;

  WebSocketDataRecievedEvent(this.data);
}

class WebSocketErrorEvent extends HomeEvent {
  final String error;

  WebSocketErrorEvent({required this.error});
}
