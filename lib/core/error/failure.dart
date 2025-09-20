import 'package:equatable/equatable.dart';

/// Abstract base class for all failure types in the application
///
/// This class provides a consistent way to handle errors across all layers
/// of the application. It extends Equatable for proper value equality
/// comparisons, which is essential for BLoC state management.
///
/// Each failure type represents a specific category of error:
/// - ServerFailure: API/server-related errors
/// - CacheFailure: Local storage/caching errors
/// - NetworkFailure: Network connectivity issues
/// - ParseFailure: JSON parsing/data format errors
/// - NotFoundFailure: Resource not found errors
abstract class Failure extends Equatable {
  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Represents server-side errors (HTTP 5xx, API errors, etc.)
///
/// Used when the remote API returns an error response or when
/// the server is unavailable. This helps distinguish between
/// network issues and actual server problems.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Represents local storage/caching errors
///
/// Used when there are issues with SharedPreferences or other
/// local storage mechanisms. This is important for offline
/// functionality and data persistence.
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Represents network connectivity issues
///
/// Used when the device cannot reach the internet or when
/// network requests timeout. This helps provide appropriate
/// offline fallback behavior.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Represents JSON parsing or data format errors
///
/// Used when the API returns data in an unexpected format
/// or when JSON parsing fails. This ensures robust error
/// handling for malformed API responses.
class ParseFailure extends Failure {
  const ParseFailure(super.message, {super.code});
}

/// Represents resource not found errors
///
/// Used when a specific country or resource cannot be found.
/// This provides specific handling for 404-type scenarios
/// in the countries API.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}
