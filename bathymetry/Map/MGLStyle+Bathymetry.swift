import Mapbox

// MARK: - MGLStyle + Bathymetry
extension MGLStyle {
    
    /// Add depth layer
    /// - Parameters:
    ///   - source: MGLShapeSource
    ///   - depth: bathymetric depth of the layer
    ///   - color: UIColor of depth layer polygon
    func addBathymetryLayer(from source: MGLShapeSource, depth: Double, color: UIColor) {
        let polygonLayer = MGLFillStyleLayer(identifier: "\(String(describing: Bundle.main.bundleIdentifier)).depth-\(depth)", source: source)
        polygonLayer.fillColor = NSExpression(forConstantValue: color.withAlphaComponent(0.3))
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: color)
        addLayer(polygonLayer)
    }
    
}
