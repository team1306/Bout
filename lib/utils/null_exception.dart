class NullException implements Exception{

  /// Error message.
  final String? message;

  /// Initializes an Appwrite Exception.
  NullException({this.message});

  /// Returns the error type, message, and code.
  @override
  String toString() {
    if (message == null || message == "") return "NullException";
    return "NullException: $message";
  }
}