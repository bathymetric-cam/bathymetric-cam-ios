import CoreLocation

// MARK: - MapTile
class MapTile: Equatable {
    
    // MARK: - property
    
    let x: Int // X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
    let y: Int // Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
    let zoom: Int
    let zoomLevel: Double // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
    let nw: CLLocationCoordinate2D // north and west coordinate
    let se: CLLocationCoordinate2D // south and east coordinate
    
    // MARK: - class method
    
    /// Gets tile identifier
    /// - Parameters:
    ///   - coordinate: lat, lng coordinate
    ///   - zoom: zoom level
    /// - Returns: "\(zoom)/\(x)/\(y)" represents a unique map tile
    class func getTileIdentifier(coordinate: CLLocationCoordinate2D, zoom: Int) -> String {
        "\(zoom)/\(Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, Double(zoom)))))/\(Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, Double(zoom)))))"
    }
    
    /// Gets tile identifier
    /// - Parameters:
    ///   - zoom: zoom level
    ///   - x: map tile x
    ///   - y: map tile y
    /// - Returns: "\(zoom)/\(x)/\(y)" represents a unique map tile
    class func getTileIdentifier(zoom: Int, x: Int, y: Int) -> String {
        "\(zoom)/\(x)/\(y)"
    }
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - zoom: map zoomLevel 
    ///   - coordinate: lat, lng coordinate
    init(zoom: Int, coordinate: CLLocationCoordinate2D) {
        zoomLevel = Double(zoom)
        x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, Double(zoom))))
        y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, Double(zoom))))
        let n = pow(2.0, zoomLevel)
        nw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y - 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x - 1) / n) * 360.0 - 180.0
        )
        se = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.zoom = zoom
    }
    
    /// Initialization
    /// - Parameters:
    ///   - zoom: map zoomLevel
    ///   - x: map tile x
    ///   - y: map tile y
    init(zoom: Int, x: Int, y: Int) {
        zoomLevel = Double(zoom)
        let n = pow(2.0, zoomLevel)
        nw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y - 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x - 1) / n) * 360.0 - 180.0
        )
        se = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.x = x
        self.y = y
        self.zoom = zoom
    }
    
    // MARK: - Equatable
    
    static func == (lhs: MapTile, rhs: MapTile) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.zoom == rhs.zoom
    }
}
