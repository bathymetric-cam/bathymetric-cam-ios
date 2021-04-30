import Combine
import ComposableArchitecture
@testable import Bathymetry

// MARK: - mock
let mockBathymetryTiles = [BathymetryTile(x: 57483, y: 25954, zoom: 16, features: [])]
let mockRegion = BathymetryRegion(
  swTile: RegionTile(x: 57483, y: 25954),
  neTile: RegionTile(x: 57483, y: 25954),
  zoom: 16
)

enum MockError: Error {
  case mock
}
let mockFailure: BathymetryClientFailure = .otherFailure(MockError.mock)

// MARK: - BathymetryClientSuccessMock
class BathymetryClientSuccessMock: BathymetryClient {
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> {
    Deferred {
      Future<[BathymetryTile], BathymetryClientFailure> { promise in
        promise(.success(mockBathymetryTiles))
      }
    }
    .eraseToEffect()
  }
}

// MARK: - BathymetryClientFailureMock
class BathymetryClientFailureMock: BathymetryClient {
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> {
    Deferred {
      Future<[BathymetryTile], BathymetryClientFailure> { promise in
        promise(.failure(mockFailure))
      }
    }
    .eraseToEffect()
  }
}
