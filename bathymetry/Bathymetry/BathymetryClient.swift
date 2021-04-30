import ComposableArchitecture
import Combine

// MARK: - BathymetryClient
protocol BathymetryClient {
  // MARK: property
  
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure>
}

// MARK: BathymetryClient

enum BathymetryClientFailure: Error, Equatable {
  
  static func == (lhs: BathymetryClientFailure, rhs: BathymetryClientFailure) -> Bool {
    switch (lhs, rhs) {
    case (.clientCreationFailure, clientCreationFailure):
      return true
    case let (.otherFailure(lhsError), .otherFailure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    default:
      return false
    }
  }
  
  case clientCreationFailure
  case otherFailure(Error)
}
/*
// MARK: - BathymetryInternalClientFactory
protocol BathymetryInternalClientFactory {
  /// Abstruct factory method
  /// - Returns: created factory
  static func createClient() -> BathymetryInternalClient?
}

// MARK: - BathymetryInternalClient
protocol BathymetryInternalClient {
  /// load Bathymetry array by the current map region
  /// - Parameters:
  ///   - region: Region
  ///   - promise: Result of the load
  func loadBathymetries(region: BathymetryRegion, promise: @escaping (Result<[BathymetryTile], BathymetryClient.Failure>) -> Void)
}
*/
