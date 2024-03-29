import CoreLocation

// MARK: - MapRegion
struct MapRegion {
  
  // MARK: enum
  
  enum Error: Swift.Error {
    case invalidZoomLevel
    case invalidXCoordinate
    case invalidYCoordinate
  }
  
  // MARK: property
  
  var swTile: MapTile
  var neTile: MapTile
  var zoom: Int { swTile.zoom }
  var sw: CLLocationCoordinate2D { swTile.sw }
  var ne: CLLocationCoordinate2D { neTile.ne }
  var center: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: (sw.latitude + ne.latitude) / 2, longitude: (sw.longitude + ne.longitude) / 2)
  }
  
  // MARK: initializer
  
  init(swTile: MapTile, neTile: MapTile) throws {
    if swTile.zoom != neTile.zoom {
      throw Error.invalidZoomLevel
    } else if neTile.y > swTile.y {
      throw Error.invalidYCoordinate
    } else if swTile.x > neTile.x {
      throw Error.invalidXCoordinate
    }
    self.swTile = swTile
    self.neTile = neTile
  }
  
  // MARK: public api
  
  /// Returns if region contains another region
  /// - Parameter region: another region
  /// - Returns: bool value if containing or not
  func contains(region: MapRegion) -> Bool {
    zoom == region.zoom &&
    swTile.x <= region.swTile.x &&
    swTile.y >= region.swTile.y &&
    neTile.x >= region.neTile.x &&
    neTile.y <= region.neTile.y
  }
}

// MARK: - MapRegion + CustomDebugStringConvertible
extension MapRegion: CustomStringConvertible {
  var description: String {
    "zoom: \(zoom), sw: (\(swTile.x), \(swTile.y)), ne: (\(neTile.x), \(neTile.y))"
  }
}

// MARK: - MapRegion + Equatable
extension MapRegion: Equatable {
  static func == (lhs: MapRegion, rhs: MapRegion) -> Bool {
      lhs.zoom == rhs.zoom &&
      lhs.swTile.x == rhs.swTile.x &&
      lhs.neTile.y == rhs.neTile.y &&
      lhs.swTile.zoom == rhs.swTile.zoom
  }
}
