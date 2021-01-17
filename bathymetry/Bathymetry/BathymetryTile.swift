import GEOSwift
import Mapbox

// MARK: - BathymetryTile
final class BathymetryTile {
    
    // MARK: - property
    
    let x: Int // X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
    let y: Int // Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
    let zoom: Int
    let zoomLevel: Double // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
    let ne: CLLocationCoordinate2D // north and east coordinate
    let sw: CLLocationCoordinate2D // south and west coordinate
    let features: [Feature]
    var name: String { "\(zoom)/\(x)/\(y)" }
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - zoom: map zoomLevel
    ///   - coordinate: lat, lng coordinate
    ///   - features: bathymetric features
    init(zoom: Int, coordinate: CLLocationCoordinate2D, features: [Feature]) {
        self.features = features
        zoomLevel = Double(zoom)
        x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, Double(zoom))))
        y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, Double(zoom))))
        let n = pow(2.0, zoomLevel)
        ne = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x + 1) / n) * 360.0 - 180.0
        )
        sw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y + 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.zoom = zoom
    }
    
    /// Initialization
    /// - Parameters:
    ///   - zoom: map zoomLevel
    ///   - x: map tile x
    ///   - y: map tile y
    ///   - features: bathymetric features
    init(zoom: Int, x: Int, y: Int, features: [Feature]) {
        self.features = features
        zoomLevel = Double(zoom)
        let n = pow(2.0, zoomLevel)
        ne = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x + 1) / n) * 360.0 - 180.0
        )
        sw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y + 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
        self.x = x
        self.y = y
        self.zoom = zoom
    }
    
    // MARK: - public api
    
    /// Gets features between minDepth and maxDepth
    /// - Parameters:
    ///   - minDepth: minimum depth
    ///   - maxDepth: maximum depth
    /// - Returns: [Feature] between the range
    func getFeatures(minDepth: Double, maxDepth: Double) -> [Feature] {
        features.compactMap { feature -> Feature? in
            guard let minDepthJSON = feature.properties?["minDepth"],
                  case let .number(low) = minDepthJSON,
                  let maxDepthJSON = feature.properties?["maxDepth"],
                  case let .number(hight) = maxDepthJSON else {
                return nil
            }
            let depth = (low + hight) / 2.0
            if depth < minDepth || depth > maxDepth {
                return nil
            }
            return feature
        }
    }
}

// MARK: - Equatable
extension BathymetryTile: Equatable {
    static func == (lhs: BathymetryTile, rhs: BathymetryTile) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.zoom == rhs.zoom
    }
}

// MARK: - Comparable
extension BathymetryTile: Comparable {
    static func <(lhs: BathymetryTile, rhs: BathymetryTile) -> Bool {
        lhs.zoom < rhs.zoom ||
        lhs.zoom == rhs.zoom && lhs.x < rhs.x ||
        lhs.zoom == rhs.zoom && lhs.x == rhs.x && lhs.y < rhs.y
    }
}
