import Mapbox

// MARK: - MGLStyle + Depth
extension MGLStyle {
    
    /// Add depth layer
    /// - Parameters:
    ///   - source: MGLShapeSource
    ///   - color: UIColor of depth layer polygon
    func addDepthLayer(from source: MGLShapeSource, color: UIColor) {
        let polygonLayer = MGLFillStyleLayer(identifier: "depth", source: source)
        polygonLayer.fillColor = NSExpression(forConstantValue: color.withAlphaComponent(0.5))
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: color)
        addLayer(polygonLayer)
    }
    
}
