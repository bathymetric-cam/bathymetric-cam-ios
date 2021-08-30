import ComposableArchitecture
import Combine
import UIKit

// MARK: - BathymetryTileClient
protocol BathymetryTileClient {
  // MARK: public api
  func loadBathymetryTile(_ region: MapRegion) -> Effect<BathymetryTile, Error>
}

// MARK: - BathymetryTileAPIClientError
enum BathymetryTileAPIClientError: Error {
  case clientError
  case serverError
  
  static func urlError(_ urlError: URLError) -> BathymetryTileAPIClientError {
    switch urlError.errorCode {
    case 400..<500:
      return .clientError
    default:
      return .serverError
    }
  }
}

// MARK: - BathymetryTileAPIClient
struct BathymetryTileAPIClient: BathymetryTileClient {
  // MARK: BathymetryTileClient
  
  func loadBathymetryTile(_ region: MapRegion) -> Effect<BathymetryTile, Error> {
    (region.swTile.x...region.neTile.x)
      .map { (x: Int) -> [BathymetryTile] in
        (region.neTile.y...region.swTile.y).compactMap { (y: Int) in .init(zoom: region.zoom, x: x, y: y) }
      }
      .reduce([]) { $0 + $1 }
      .compactMap { (tile: BathymetryTile) -> (tile: BathymetryTile, imageUrl: URL)? in
        guard let imageUrl = tile.imageUrl else {
          return nil
        }
        return (tile: tile, imageUrl: imageUrl)
      }
      .publisher
      .flatMap { (tuple: (tile: BathymetryTile, imageUrl: URL)) in
        URLSession.shared.dataTaskPublisher(for: tuple.imageUrl)
          .validate(statusCode: 200..<300)
          .mapError { BathymetryTileAPIClientError.urlError($0) }
          .map { UIImage(data: $0.data) }
          .map { BathymetryTile(zoom: tuple.tile.zoom, x: tuple.tile.x, y: tuple.tile.y, image: $0) }
      }
      .eraseToEffect()
  }
}

// MARK: BathymetryTile + BathymetryTileAPIClient
extension BathymetryTile {
  var imageUrl: URL? {
    URL(string: "\(zoom).\(x).\(y).png")
  }
}
