import GEOSwift
import Mapbox

// MARK: - MGLShapeSource+BathymetryTile
extension MGLShapeSource {
    
    // MARK: - initialization
    
    /// Inits
    /// - Parameter feature: Feature
    convenience init(identifier: String, feature: Feature) {
        self.init(
            identifier: identifier,
            features: [feature].compactMap { $0.geometry?.mapboxFeature() },
            options: nil
        )
    }
}
