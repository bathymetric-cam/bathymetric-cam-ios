import GEOSwift
import Mapbox

// MARK: - BathymetryTile
final class BathymetryTile: RegionTile {
    
    // MARK: property
    
    let zoom: Int
    let zoomLevel: Double // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
    let features: [Feature]
    
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
    
    // MARK: initialization
    
    /// Initialization
    /// - Parameters:
    ///   - coordinate: lat, lng coordinate
    ///   - zoom: map zoomLevel   
    ///   - features: bathymetric features
    init(coordinate: CLLocationCoordinate2D, zoom: Int, features: [Feature]) {
        self.features = features
        self.zoom = zoom
        zoomLevel = Double(zoom)
        super.init(coordinate: coordinate, zoom: zoom)
    }
    
    /// Initialization
    /// - Parameters:
    ///   - x: map tile x
    ///   - y: map tile y
    ///   - zoom: map zoomLevel
    ///   - features: bathymetric features
    init(x: Int, y: Int, zoom: Int, features: [Feature]) {
        self.features = features
        self.zoom = zoom
        zoomLevel = Double(zoom)
        super.init(x: x, y: y)
    }
    
    // MARK: public api
    
    /// Gets features between minDepth and maxDepth
    /// - Parameters:
    ///   - depth: depth range
    /// - Returns: [Feature] between the range
    func getFeatures(depth: BathymetryDepth) -> [Feature] {
        features.compactMap { feature -> Feature? in
            guard let minDepthJSON = feature.properties?["minDepth"],
                  case let .number(low) = minDepthJSON,
                  let maxDepthJSON = feature.properties?["maxDepth"],
                  case let .number(high) = maxDepthJSON else {
                return nil
            }
            return low >= depth.min && high <= depth.max ? feature : nil
        }
    }
}

// MARK: - BathymetryTile + Equatable
extension BathymetryTile {
    static func == (lhs: BathymetryTile, rhs: BathymetryTile) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.zoom == rhs.zoom
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

// MARK: - RegionTile
class RegionTile {
    
    // MARK: property
    
    // let zoom: Int
    let x: Int // X goes from 0 (left edge is 180 °W) to 2zoom − 1 (right edge is 180 °E)
    let y: Int // Y goes from 0 (top edge is 85.0511 °N) to 2zoom − 1 (bottom edge is 85.0511 °S) in a Mercator projection
    
    // MARK: initialization
    
    /// Initialization
    /// - Parameters:
    ///   - coordinate: lat, lng coordinate
    ///   - zoom: map zoomLevel
    init(coordinate: CLLocationCoordinate2D, zoom: Int) {
        x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, Double(zoom))))
        y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, Double(zoom))))
    }
    
    /// Initialization
    /// - Parameters:
    ///   - x: map tile x
    ///   - y: map tile y
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// MARK: - RegionTile + Equatable
extension RegionTile: Equatable {
    static func == (lhs: RegionTile, rhs: RegionTile) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
