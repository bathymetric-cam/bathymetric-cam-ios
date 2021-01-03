import GEOSwift
import Mapbox

// MARK: - Bathymetry
final class Bathymetry: Equatable {
    
    // MARK: - property
    
    private var features: [Feature]
    
    var mapboxSource: MGLShapeSource
    var mapboxLayer: MGLFillStyleLayer
    
    // MARK: - Equatable
    
    static func == (lhs: Bathymetry, rhs: Bathymetry) -> Bool {
        return lhs.mapboxSource.identifier == rhs.mapboxSource.identifier
    }
    
    // MARK: - class method
    
    /// Create bathymetry by features
    /// - Parameters:
    ///   - features: bathymetric features
    /// - Returns: [Bathymetry]
    class func createBathymetries(features: [Feature]) -> [Bathymetry] {
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
        return featuresByTile.map {
            Bathymetry(tileIdentifier: $0.key, features: $0.value)
        }
    }
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - tileIdentifier: "\(zoom)/\(x)/\(y)" represents a unique map tile
    ///   - features: bathymetric features
    init(tileIdentifier: String, features: [Feature]) {
        self.features = features
        mapboxSource = MGLShapeSource(
            identifier: "\(String(describing: Bundle.main.bundleIdentifier)).source.\(tileIdentifier)",
            features: features.compactMap { ($0.properties?["depth"] == 1.0) ? $0.geometry?.mapboxFeature() : nil },
            options: nil
        )
        mapboxLayer = MGLFillStyleLayer(identifier: "\(String(describing: Bundle.main.bundleIdentifier)).layer", source: mapboxSource)
        mapboxLayer.fillColor = NSExpression(forConstantValue: UIColor.systemBlue.withAlphaComponent(0.3))
        mapboxLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.systemBlue)
    }

}
