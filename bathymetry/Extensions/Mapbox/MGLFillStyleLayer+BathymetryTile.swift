import Mapbox

// MARK: - MGLFillStyleLayer+BathymetryTile
extension MGLFillStyleLayer {
    // MARK: - initialization
    
    convenience init(bathymetryTile: BathymetryTile, source: MGLSource) {
        self.init(
            identifier: "\(Bundle.main.bundleIdentifier ?? "").layer.\(bathymetryTile.name)",
            source: source
        )
    }
}
