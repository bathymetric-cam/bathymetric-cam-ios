import ComposableArchitecture
import Combine

// MARK: - BathymetryClient
protocol BathymetryClient {
  // MARK: property
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure>
}

// MARK: BathymetryClientFailure
enum BathymetryClientFailure: Error {
  case otherFailure(Error)
}

// MARK: - BathymetryClientFailure + Equatable
extension BathymetryClientFailure: Equatable {
  // MARK: Equatable
  static func == (lhs: BathymetryClientFailure, rhs: BathymetryClientFailure) -> Bool {
    switch (lhs, rhs) {
    case let (.otherFailure(lhsError), .otherFailure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    }
  }
}

// MARK: - BathymetryClientFailure + LocalizedError
extension BathymetryClientFailure: LocalizedError {
    var errorDescription: String? {
      switch self {
      case let .otherFailure(error):
        return error.localizedDescription
      }
    }
}

// MARK: - BathymetryClientFailure + CustomStringConvertible
extension BathymetryClientFailure: CustomStringConvertible {
  var description: String {
    switch self {
    case let .otherFailure(error):
      return error.localizedDescription
    }
  }
}
