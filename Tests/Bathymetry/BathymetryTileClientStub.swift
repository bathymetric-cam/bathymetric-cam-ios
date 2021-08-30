import Combine
import ComposableArchitecture
@testable import Bathymetry

// MARK: - BathymetryTileClientStub
class BathymetryTileClientStub: BathymetryTileClient {
  
  // MARK: enum
  
  enum BathymetryTileClientStubError: Error {
    case unknown
  }
  
  // MARK: property
  
  let result: Result<BathymetryTile, Error>
  
  // MARK: initializer
  
  init(result: Result<BathymetryTile, Error>) {
    self.result = result
  }
  
  // MARK: BathymetryTileClient
  
  func loadBathymetryTile(_ region: MapRegion) -> Effect<BathymetryTile, Error> {
    Deferred { [weak self] in
      Future<BathymetryTile, Error> { [weak self] promise in
        switch self?.result {
        case let .success(tile):
          promise(.success(tile))
        case let .failure(error):
          promise(.failure(error))
        case .none:
          promise(.failure(BathymetryTileClientStubError.unknown))
        }
      }
    }
    .eraseToEffect()
  }
}
