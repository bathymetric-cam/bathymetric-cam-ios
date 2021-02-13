// MARK: - BathymetryZoomLevel
typealias BathymetryZoomLevel = Double
extension BathymetryZoomLevel {
  // MARK: static constant
  
  static let min: BathymetryZoomLevel = 14.0
  static let max: BathymetryZoomLevel = 16.0
  
  // MARK: public api
  
  /// Zoom in
  mutating func zoomIn() {
    self += 0.5
    if self > .max {
      self = .max
    }
  }
  
  /// Zoom out
  mutating func zoomOut() {
    self -= 0.5
    if self < .min {
      self = .min
    }
  }
}
