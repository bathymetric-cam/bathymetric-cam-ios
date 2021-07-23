import Combine
import ComposableArchitecture
@testable import Bathymetry

// MARK: - Tests
let testBathymetryTiles = [BathymetryTile(x: 57483, y: 25954, zoom: 16, features: [])]
let testRegion = BathymetryRegion(
  swTile: RegionTile(x: 57483, y: 25954),
  neTile: RegionTile(x: 57483, y: 25954),
  zoom: 16
)

enum TestError: Error {
  case test
}
let testFailure: BathymetryClientFailure = .otherFailure(TestError.test)

// MARK: - BathymetryClientSuccessFake
class BathymetryClientSuccessFake: BathymetryClient {
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> {
    Deferred {
      Future<[BathymetryTile], BathymetryClientFailure> { promise in
        promise(.success(testBathymetryTiles))
      }
    }
    .eraseToEffect()
  }
}

// MARK: - BathymetryClientFailureFake
class BathymetryClientFailureFake: BathymetryClient {
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> {
    Deferred {
      Future<[BathymetryTile], BathymetryClientFailure> { promise in
        promise(.failure(testFailure))
      }
    }
    .eraseToEffect()
  }
}
