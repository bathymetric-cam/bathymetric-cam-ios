import GEOSwift
import Mapbox

// MARK: - Bathymetry
final class Bathymetry: Equatable {
    
    // MARK: - property
    
    private var features: [Feature]
    var depth: Double
    var color: UIColor
    
    var mapboxSource: MGLShapeSource
    var mapboxLayer: MGLFillStyleLayer
    
    // MARK: - Equatable
    
    static func == (lhs: Bathymetry, rhs: Bathymetry) -> Bool {
        return lhs.mapboxSource.identifier == rhs.mapboxSource.identifier
    }
    
    // MARK: - class method
    
    /// Create bathymetry by features
    /// - Parameters:
    ///   - color: color of the layer
    ///   - features: bathymetric features
    /// - Returns: [Bathymetry]
    class func createBathymetries(color: UIColor, features: [Feature]) -> [Bathymetry] {
        var depths: [Double: [Feature]] = [:]
        for feature in features {
            guard case let .number(depth) = feature.properties?["depth"] else {
                continue
            }
            if var features = depths[depth] {
                features.append(feature)
            } else {
                depths[depth] = [feature]
            }
        }
        return depths.map { Bathymetry(color: UIColor.systemBlue, depth: $0.key, features: $0.value) }
    }
    
    // MARK: - initialization
    
    /// Initialization
    /// - Parameters:
    ///   - color: color of the layer
    ///   - depth: depth of bathymetric features
    ///   - features: bathymetric features
    init(color: UIColor, depth: Double, features: [Feature]) {
        self.color = color
        self.depth = depth
        self.features = features
        mapboxSource = MGLShapeSource(
            identifier: "\(String(describing: Bundle.main.bundleIdentifier)).source-\(depth)",
            features: features.compactMap { ($0.properties?["depth"] == 1.0) ? $0.geometry?.mapboxFeature() : nil },
            options: nil
        )
        mapboxLayer = MGLFillStyleLayer(identifier: "\(String(describing: Bundle.main.bundleIdentifier)).layer-\(depth)", source: mapboxSource)
        mapboxLayer.fillColor = NSExpression(forConstantValue: color.withAlphaComponent(0.3))
        mapboxLayer.fillOutlineColor = NSExpression(forConstantValue: color)
    }

}
