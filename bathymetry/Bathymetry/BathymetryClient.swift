import ComposableArchitecture
import Combine

// MARK: - BathymetryClient
protocol BathymetryClient {
  // MARK: property
  
  var loadBathymetries: (_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> { get }
}

// MARK: BathymetryClient

enum BathymetryClientFailure: Error, Equatable {
  
  static func == (lhs: BathymetryClientFailure, rhs: BathymetryClientFailure) -> Bool {
    switch (lhs, rhs) {
    case let (.otherFailure(lhsError), .otherFailure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    }
  }
  
  case otherFailure(Error)
}
