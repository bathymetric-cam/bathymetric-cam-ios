import GEOSwift

// MARK: - MapBathymetryTile
final class MapBathymetryTile: MapTile {
    
    // MARK: - property
    
    private var features: [Feature]
    
    // MARK: - class method
    
    /// Create bathymetry by features
    /// - Parameters:
    ///   - features: bathymetric features
    /// - Returns: [Bathymetry]
    class func createMapBathymetryTile(features: [Feature]) -> [MapBathymetryTile] {
        var featuresByTile: [String: [Feature]] = [:]
        for feature in features {
            guard case let .number(x) = feature.properties?["x"],
                  case let .number(y) = feature.properties?["y"],
                  case let .number(zoom) = feature.properties?["zoom"] else {
                continue
            }
            let tileId = MapTile.getTileIdentifier(zoom: Int(zoom), x: Int(x), y: Int(y))
            if var features = featuresByTile[tileId] {
                features.append(feature)
            } else {
                featuresByTile[tileId] = [feature]
            }
        }
        return featuresByTile.compactMap {
            let keys = "\($0.key)".split(separator: "/").map { Int($0) }
            guard let zoom = keys[0], let x = keys[1], let y = keys[2] else {
                return nil
            }
            return MapBathymetryTile(zoom: zoom, x: x, y: y, features: $0.value)
        }
    }
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - zoom: zoom level
    ///   - x: map tile x
    ///   - y: map tile y
    ///   - features: bathymetric features
    init(zoom: Int, x: Int, y: Int, features: [Feature]) {
        self.features = features
        super.init(zoom: zoom, x: x, y: y)
    }
}
