import Mapbox

// MARK: - MGLShapeSource+BathymetryTile
extension MGLShapeSource {
    // MARK: - initialization
    
    /// Inits
    /// - Parameter bathymetryTile: BathymetryTile
    convenience init(bathymetryTile: BathymetryTile) {
        self.init(
            identifier: "\(Bundle.main.bundleIdentifier ?? "").source.\(bathymetryTile.name)",
            features: bathymetryTile.features.compactMap { $0.geometry?.mapboxFeature() },
            options: nil
        )
    }
}
