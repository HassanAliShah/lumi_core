/// Custom exception class to handle network and API related errors.
class TNetworkException implements Exception {
  /// The associated error message.
  final String message;

  /// HTTP status code when the API returned a response.
  final int? statusCode;

  /// Default constructor with a generic network error message.
  const TNetworkException([
    this.message = 'Unable to complete request. Please try again.',
    this.statusCode,
  ]);

  /// Create a network exception from a specific error message.
  factory TNetworkException.fromMessage(String message) {
    return TNetworkException(message);
  }

  /// Create a network exception from an HTTP status code.
  factory TNetworkException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const TNetworkException(
          'Invalid request. Please check your input and try again.',
          400,
        );
      case 401:
        return const TNetworkException(
          'Unauthorized request. Please verify your API key.',
          401,
        );
      case 404:
        return const TNetworkException(
          'City not found. Please verify the name and try again.',
          404,
        );
      case 408:
        return const TNetworkException(
          'Request timeout. Please check your connection and try again.',
          408,
        );
      case 429:
        return const TNetworkException(
          'Server is busy right now. Please try again later.',
          429,
        );
      default:
        if (statusCode >= 500) {
          return TNetworkException(
            'Server error encountered. Please try again later.',
            statusCode,
          );
        }

        return TNetworkException(
          'Failed to load data. Status code: $statusCode',
          statusCode,
        );
    }
  }

  /// Whether cached weather can be shown as a safe fallback.
  bool get canUseCachedWeather {
    return statusCode == null ||
        statusCode == 408 ||
        statusCode == 429 ||
        statusCode! >= 500;
  }

  @override
  String toString() => message;
}
