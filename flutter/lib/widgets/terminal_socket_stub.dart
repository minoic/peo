class TerminalSocket {
  TerminalSocket(
    String url,
    void Function() onOpen,
    void Function(String) onMessage,
    void Function() onClose,
  ) {
    throw UnsupportedError('The terminal is only supported in the web app.');
  }

  void send(String message) {}
  void close() {}
}
