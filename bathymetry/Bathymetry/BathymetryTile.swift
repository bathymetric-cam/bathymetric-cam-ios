import GEOSwift
import Mapbox

// MARK: - BathymetryTile
final class BathymetryTile: RegionTile {
    
    // MARK: property
    
    let zoom: Int
    let zoomLevel: Double // The zoom parameter is an integer between 0 (zoomed out) and 18 (zoomed in). 18 is normally the maximum, but some tile servers might go beyond that.
    let features: [Feature]
    var name: String { "\(zoom)/\(x)/\(y)" }
    
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
        super.init(x: x, y: y, zoom: zoom)
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
    let ne: CLLocationCoordinate2D // north and east coordinate
    let sw: CLLocationCoordinate2D // south and west coordinate
    
    // MARK: initialization
    
    /// Initialization
    /// - Parameters:
    ///   - coordinate: lat, lng coordinate
    ///   - zoom: map zoomLevel
    init(coordinate: CLLocationCoordinate2D, zoom: Int) {
        x = Int(floor((coordinate.longitude + 180.0) / 360.0 * pow(2.0, Double(zoom))))
        y = Int(floor((1.0 - log(tan(coordinate.latitude * .pi / 180.0) + 1.0 / cos(coordinate.latitude * .pi / 180.0)) / .pi) / 2.0 * pow(2.0, Double(zoom))))
        let n = pow(2.0, Double(zoom))
        ne = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x + 1) / n) * 360.0 - 180.0
        )
        sw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y + 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
    }
    
    /// Initialization
    /// - Parameters:
    ///   - x: map tile x
    ///   - y: map tile y
    ///   - zoom: map zoomLevel
    init(x: Int, y: Int, zoom: Int) {
        self.x = x
        self.y = y
        let n = pow(2.0, Double(zoom))
        ne = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x + 1) / n) * 360.0 - 180.0
        )
        sw = CLLocationCoordinate2D(
            latitude: atan(sinh(.pi - (Double(y + 1) / n) * 2.0 * .pi)) * (180.0 / .pi),
            longitude: (Double(x) / n) * 360.0 - 180.0
        )
    }
}

// MARK: - RegionTile + Equatable
extension RegionTile: Equatable {
    static func == (lhs: RegionTile, rhs: RegionTile) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Region
struct Region {
    
    // MARK: property
    
    var swTile: RegionTile
    var neTile: RegionTile
    var zoom: Int
    
    // MARK: public api
    
    /// Returns if region contains another region
    /// - Parameter region: another region
    /// - Returns: bool value if containing or not
    func contains(region: Region) -> Bool {
        swTile.sw.latitude <= region.swTile.sw.latitude &&
        swTile.sw.longitude <= region.swTile.sw.longitude &&
        neTile.ne.latitude >= region.neTile.ne.latitude &&
        neTile.ne.longitude >= region.neTile.ne.longitude
    }
    
    /// Returns doubled region (center coordinate doesn't change)
    /// - Returns: doubled region
    func doubled() -> Region {
        Region(
            swTile: RegionTile(
                coordinate: CLLocationCoordinate2D(
                    latitude: swTile.sw.latitude - (neTile.ne.latitude - swTile.sw.latitude) / 2,
                    longitude: swTile.sw.longitude - (neTile.ne.longitude - swTile.sw.longitude) / 2
                ),
                zoom: zoom
            ),
            neTile: RegionTile(
                coordinate: CLLocationCoordinate2D(
                    latitude: neTile.ne.latitude + (neTile.ne.latitude - swTile.sw.latitude) / 2,
                    longitude: neTile.ne.longitude + (neTile.ne.longitude - swTile.sw.longitude) / 2
                ),
                zoom: zoom
            ),
            zoom: zoom
        )
    }
}

// MARK: - Region + Equatable
extension Region: Equatable {
    static func == (lhs: Region, rhs: Region) -> Bool {
        lhs.swTile == rhs.swTile && lhs.neTile == rhs.neTile
    }
}
