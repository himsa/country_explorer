/// Abstract base class for all use cases in the application
///
/// This follows the Clean Architecture principle where use cases encapsulate
/// business logic and are independent of the presentation and data layers.
///
/// Use cases represent single business operations and should:
/// - Contain only business logic
/// - Be testable in isolation
/// - Not depend on external frameworks
/// - Have a single responsibility
///
/// [ReturnType] - The type of data returned by the use case
/// [Params] - The type of parameters required by the use case
abstract class UseCase<ReturnType, Params> {
  /// Executes the use case with the provided parameters
  ///
  /// This method should contain the core business logic for the use case.
  /// It should be pure and not have side effects beyond the business operation.
  Future<ReturnType> call(Params params);
}

/// Empty parameter class for use cases that don't require parameters
///
/// This is used when a use case doesn't need any input parameters.
/// For example, fetching all countries doesn't require any parameters,
/// so it would use NoParams as its parameter type.
class NoParams {}
