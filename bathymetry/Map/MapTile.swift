import CoreLocation

// MARK: - MapTile
class MapTile {
    
    // MARK: - property
    
    let x: Int // X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
    let y: Int // Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
    let zoomLevel: Double // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - coordinate: lat, lng coordinate
    ///   - zoomLevel: map zoomLevel
    init(coordinate: CLLocationCoordinate2D, zoomLevel: Double) {
        x = Int(floor((coordinate.longitude + 180) / 360.0 * pow(2.0, zoomLevel)))
        y = Int(floor((1 - log( tan( coordinate.latitude * Double.pi / 180.0 ) + 1 / cos( coordinate.latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, zoomLevel)))
        let n = pow(2.0, zoomLevel)
        self.coordinate = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2 * Double.pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.zoomLevel = zoomLevel
    }
    
    /// Initialization
    /// - Parameters:
    ///   - x: map tile x
    ///   - y: map tile y
    ///   - zoomLevel: map zoomLevel
    init(x: Int, y: Int, zoomLevel: Double) {
        let n = pow(2.0, zoomLevel)
        coordinate = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2 * Double.pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.x = x
        self.y = y
        self.zoomLevel = zoomLevel
    }
}
