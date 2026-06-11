/// Custom exception class to handle local cache related errors.
class TCacheException implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic cache error message.
  const TCacheException([
    this.message = 'Unable to load cached data. Please try again.',
  ]);

  @override
  String toString() => message;
}
