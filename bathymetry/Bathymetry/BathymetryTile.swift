// import GEOSwift
import CoreLocation

// MARK: - BathymetryTile
struct BathymetryTile {
  
  // MARK: property
  
  let zoom: Int
  let zoomLevel: BathymetryZoomLevel // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
  
  let x: Int // X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
  let y: Int // Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
  
  var name: String { "\(zoom)/\(x)/\(y)" }
  var ne: CLLocationCoordinate2D { // north and east coordinate
    CLLocationCoordinate2D(
      latitude: atan(sinh(.pi - (Double(y) / pow(2.0, zoomLevel)) * 2.0 * .pi)) * (180.0 / .pi),
      longitude: (Double(x + 1) / pow(2.0, zoomLevel)) * 360.0 - 180.0
    )
  }
  var sw: CLLocationCoordinate2D { // south and west coordinate
    CLLocationCoordinate2D(
      latitude: atan(sinh(.pi - (Double(y + 1) / pow(2.0, zoomLevel)) * 2.0 * .pi)) * (180.0 / .pi),
      longitude: (Double(x) / pow(2.0, zoomLevel)) * 360.0 - 180.0
    )
  }
  
  // MARK: initializer
  
  /// initializer
  /// - Parameters:
  ///   - coordinate: lat, lng coordinate
  ///   - zoom: map zoomLevel
  init(coordinate: CLLocationCoordinate2D, zoom: Int) {
    self.zoom = zoom
    zoomLevel = BathymetryZoomLevel(zoom)
    // super.init(coordinate: coordinate, zoom: zoom)
    x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, BathymetryZoomLevel(zoom))))
    y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, BathymetryZoomLevel(zoom))))
  }
  
  /// initializer
  /// - Parameters:
  ///   - x: map tile x
  ///   - y: map tile y
  ///   - zoom: map zoomLevel
  init(x: Int, y: Int, zoom: Int) {
    self.zoom = zoom
    zoomLevel = BathymetryZoomLevel(zoom)
    // super.init(x: x, y: y)
    self.x = x
    self.y = y
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
