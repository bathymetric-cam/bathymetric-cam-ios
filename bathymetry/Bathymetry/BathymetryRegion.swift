// MARK: - BathymetryRegion
struct BathymetryRegion {
  
  // MARK: enum
  
  enum Error: Swift.Error {
    case invalidZoomLevel
    case invalidXCoordinate
    case invalidYCoordinate
  }
  
  // MARK: property
  
  var swTile: BathymetryTile
  var neTile: BathymetryTile
  var zoom: Int {
    swTile.zoom
  }
  
  // MARK: initializer
  
  init(swTile: BathymetryTile, neTile: BathymetryTile) throws {
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
  func contains(region: BathymetryRegion) -> Bool {
    zoom == region.zoom &&
    swTile.x <= region.swTile.x &&
    swTile.y >= region.swTile.y &&
    neTile.x >= region.neTile.x &&
    neTile.y <= region.neTile.y
  }
  
  /// Returns larger region
  /// - Returns: larger region
  func largerRegion() throws -> BathymetryRegion {
    let x = neTile.x - swTile.x <= 0 ? 1 : neTile.x - swTile.x
    let y = swTile.y - neTile.y <= 0 ? 1 : swTile.y - neTile.y
    return try BathymetryRegion(
      swTile: BathymetryTile(x: swTile.x - x, y: swTile.y + y, zoom: zoom),
      neTile: BathymetryTile(x: neTile.x + x, y: neTile.y - y, zoom: zoom)
    )
  }
}

// MARK: - BathymetryRegion + Equatable
extension BathymetryRegion: Equatable {
  static func == (lhs: BathymetryRegion, rhs: BathymetryRegion) -> Bool {
    lhs.zoom == rhs.zoom && lhs.swTile == rhs.swTile && lhs.neTile == rhs.neTile
  }
}
