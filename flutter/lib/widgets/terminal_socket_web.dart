import 'dart:js_interop';

import 'package:web/web.dart' as web;

class TerminalSocket {
  TerminalSocket(String url, this.onOpen, this.onMessage, this.onClose)
    : _socket = web.WebSocket(url) {
    _socket.onopen = ((web.Event _) => onOpen()).toJS;
    _socket.onmessage = ((web.Event event) {
      final data = (event as web.MessageEvent).data;
      if (data != null && data.typeofEquals('string')) {
        onMessage((data as JSString).toDart);
      }
    }).toJS;
    _socket.onclose = ((web.Event _) => onClose()).toJS;
  }

  final void Function(String) onMessage;
  final void Function() onOpen;
  final void Function() onClose;
  final web.WebSocket _socket;

  void send(String message) {
    if (_socket.readyState == web.WebSocket.OPEN) _socket.send(message.toJS);
  }

  void close() => _socket.close();
}
