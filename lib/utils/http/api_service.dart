import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lumi_core/utils/constants/api_constants.dart';
import 'package:lumi_core/utils/exceptions/network_exceptions.dart';

/// Reusable API service for making HTTP requests from repositories.
class TApiService {
  /// HTTP client is injected to keep repositories and tests easy to control.
  final http.Client _client;

  /// Base URL for the selected weather API.
  final String _baseUrl;

  /// Creates an API service with an optional custom client and base URL.
  TApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? TAPIs.openWeatherBaseUrl;

  /// Helper method to make a GET request.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      throw const TNetworkException(
        'No Internet connection. Please check your network settings.',
      );
    } on TimeoutException {
      throw const TNetworkException(
        'Request timeout. Please check your connection and try again.',
      );
    } on FormatException {
      throw const TNetworkException(
        'Invalid response received from server. Please try again.',
      );
    } on TNetworkException {
      rethrow;
    } catch (e) {
      throw TNetworkException('An unexpected error occurred: $e');
    }
  }

  /// Builds a valid request URI from an endpoint and optional query parameters.
  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final normalizedBaseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;

    return Uri.parse('$normalizedBaseUrl/$normalizedEndpoint').replace(
      queryParameters: queryParameters,
    );
  }

  /// Handle the HTTP response with precise, user-friendly domain exceptions.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      final decodedBody = json.decode(response.body);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody;
      }

      throw const TNetworkException(
        'Invalid response received from server. Please try again.',
      );
    }

    throw TNetworkException.fromStatusCode(statusCode);
  }

  /// Close the HTTP client when the service is no longer needed.
  void close() => _client.close();
}
