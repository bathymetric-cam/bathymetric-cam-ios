import Mapbox

// MARK: - MGLStyle + Polygon
extension MGLStyle {
     
    func addPolygons(from source: MGLShapeSource) {
        let polygonLayer = MGLFillStyleLayer(identifier: "depth", source: source)
        polygonLayer.predicate = NSPredicate(format: "depth = 1.0")
        polygonLayer.fillColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 0.3))
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 1.0))
        addLayer(polygonLayer)
    }
    
}
