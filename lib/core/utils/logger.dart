class Logger {
  Logger._();

  static void log(String message) {
    // Basic console logging for debugging.
    // Replace this with a more advanced logger if desired.
    final timestamp = DateTime.now().toIso8601String();
    // ignore: avoid_print
    print('[flutter_post_blog] [$timestamp] $message');
  }
}
