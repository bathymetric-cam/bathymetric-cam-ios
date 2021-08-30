import ComposableArchitecture

// MARK: - BathymetryTileClient
protocol BathymetryTileClient {
  // MARK: public api
  func loadBathymetryTile(region: MapRegion) -> Effect<BathymetryTile, BathymetryTileClientError>
}

// MARK: - BathymetryTileClientError
enum BathymetryTileClientError: Error {
  case client
  case server
  
  static func urlError(_ urlError: URLError) -> BathymetryTileClientError {
    switch urlError.errorCode {
    case 400..<500:
      return .client
    default:
      return .server
    }
  }
}
