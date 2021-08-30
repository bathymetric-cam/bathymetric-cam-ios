import Combine
import ComposableArchitecture
@testable import Bathymetry

// MARK: - BathymetryTileClientStub
class BathymetryTileClientStub: BathymetryTileClient {
  // MARK: property
  
  let result: Result<BathymetryTile, BathymetryTileClientError>
  
  // MARK: initializer
  
  init(result: Result<BathymetryTile, BathymetryTileClientError>) {
    self.result = result
  }
  
  // MARK: BathymetryTileClient
  
  func loadBathymetryTile(region: MapRegion) -> Effect<BathymetryTile, BathymetryTileClientError> {
    Deferred { [weak self] in
      Future<BathymetryTile, BathymetryTileClientError> { [weak self] promise in
        switch self?.result {
        case let .success(tile):
          promise(.success(tile))
        case let .failure(error):
          promise(.failure(error))
        case .none:
          promise(.failure(.client))
        }
      }
    }
    .eraseToEffect()
  }
}
