import 'dart:html' as html;

/// Network information interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Web implementation of NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For web, we assume connection is available
    // In a real implementation, you might check navigator.onLine
    return html.window.navigator.onLine ?? true;
  }
}
