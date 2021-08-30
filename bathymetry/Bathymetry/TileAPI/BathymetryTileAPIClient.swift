import Combine
import ComposableArchitecture
import UIKit

// MARK: - BathymetryTileAPIClient
struct BathymetryTileAPIClient: BathymetryTileClient {
  
  // MARK: property
  
  private let baseUrlString: String
  
  // MARK: initializer
  
  init() {
    guard let path = Bundle.main.path(forResource: "BathymetryTileAPIClient-Info", ofType: "plist") else {
      fatalError("Cannot open BathymetryTileAPIClient-Info.plist")
    }
    guard let plist = NSDictionary(contentsOfFile: path),
          let baseUrlString = plist["baseUrl"] as? String else {
      fatalError("Invalid BathymetryTileAPIClient-Info.plist")
    }
    self.baseUrlString = baseUrlString
  }
  
  // MARK: BathymetryTileClient
  
  func loadBathymetryTile(region: MapRegion) -> Effect<BathymetryTile, BathymetryTileClientError> {
    (region.swTile.x...region.neTile.x)
      .map { (x: Int) -> [BathymetryTile] in
        (region.neTile.y...region.swTile.y).compactMap { (y: Int) in .init(zoom: region.zoom, x: x, y: y) }
      }
      .reduce([]) { $0 + $1 }
      .compactMap { (tile: BathymetryTile) -> (tile: BathymetryTile, imageUrl: URL)? in
        guard let imageUrl = URL(string: "\(baseUrlString)/\(tile.zoom)/\(tile.x)/\(tile.y).png") else {
          return nil
        }
        return (tile: tile, imageUrl: imageUrl)
      }
      .publisher
      .flatMap { (tuple: (tile: BathymetryTile, imageUrl: URL)) in
        URLSession.shared.dataTaskPublisher(for: tuple.imageUrl)
          .validate(statusCode: 200..<300)
          .mapError { BathymetryTileClientError.urlError($0) }
          .map { UIImage(data: $0.data) }
          .map { BathymetryTile(zoom: tuple.tile.zoom, x: tuple.tile.x, y: tuple.tile.y, image: $0) }
      }
      .eraseToEffect()
  }
}
