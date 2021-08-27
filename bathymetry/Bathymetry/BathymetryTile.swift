import CoreLocation
import UIKit

// MARK: - BathymetryTile
struct BathymetryTile: MapTile {
  
  // MARK: property
  
  let zoom: Int
  let x: Int
  let y: Int
  
  var image: UIImage?
  
  // MARK: initializer
  
  /// initializer
  /// - Parameters:
  ///   - zoom: map zoomLevel
  ///   - coordinate: lat, lng coordinate
  ///   - image: tile image
  init(zoom: Int, coordinate: CLLocationCoordinate2D, image: UIImage? = nil) {
    self.zoom = zoom
    x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, BathymetryZoomLevel(zoom))))
    y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, BathymetryZoomLevel(zoom))))
    self.image = image
  }
  
  /// initializer
  /// - Parameters:
  ///   - zoom: map zoomLevel
  ///   - x: map tile x
  ///   - y: map tile y
  ///   - image: tile image   
  init(zoom: Int, x: Int, y: Int, image: UIImage? = nil) {
    self.zoom = zoom
    self.x = x
    self.y = y
    self.image = image
  }
}

// MARK: - BathymetryTile + Equatable
extension BathymetryTile: Equatable {
  static func == (lhs: BathymetryTile, rhs: BathymetryTile) -> Bool {
    lhs.zoom == rhs.zoom && lhs.x == rhs.x && lhs.y == rhs.y
  }
}

// MARK: - BathymetryTile + Comparable
extension BathymetryTile: Comparable {
  static func < (lhs: BathymetryTile, rhs: BathymetryTile) -> Bool {
    lhs.zoom < rhs.zoom ||
    lhs.zoom == rhs.zoom && lhs.x < rhs.x ||
    lhs.zoom == rhs.zoom && lhs.x == rhs.x && lhs.y < rhs.y
  }
}
