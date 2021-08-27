import CoreLocation

// MARK: - MapTile
protocol MapTile {
  // MARK: property
  
  /// The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
  var zoom: Int { get }
  /// X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
  var x: Int { get }
  /// Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
  var y: Int { get }
  
}

// MARK: - MapTile + Default Property
extension MapTile {
  // MARK: property
  
  var name: String { "\(zoom)/\(x)/\(y)" }
  var zoomLevel: BathymetryZoomLevel { BathymetryZoomLevel(zoom) }
  
  /// north and east coordinate
  var ne: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: atan(sinh(.pi - (Double(y) / pow(2.0, zoomLevel)) * 2.0 * .pi)) * (180.0 / .pi),
      longitude: (Double(x + 1) / pow(2.0, zoomLevel)) * 360.0 - 180.0
    )
  }
  /// south and west coordinate
  var sw: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: atan(sinh(.pi - (Double(y + 1) / pow(2.0, zoomLevel)) * 2.0 * .pi)) * (180.0 / .pi),
      longitude: (Double(x) / pow(2.0, zoomLevel)) * 360.0 - 180.0
    )
  }
}
