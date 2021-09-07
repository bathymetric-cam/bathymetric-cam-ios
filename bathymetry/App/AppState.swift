import CoreLocation
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
  // MARK: property
  
  var bathymetryTiles = [BathymetryTile]()
  var bathymetries: [Bathymetry]
  var zoomLevel = BathymetryZoomLevel.max
  var region = try? MapRegion(
    swTile: BathymetryTile(zoom: Int(BathymetryZoomLevel.max), x: 0, y: 0),
    neTile: BathymetryTile(zoom: Int(BathymetryZoomLevel.max), x: 0, y: 0)
  )
  var arIsOn = true
  var waterSurface = -1.5
  let waterSurfaceTop = -0.5
  let waterSurfaceBottom = -15.0
  var depthUnit: BathymetryDepthUnit = .meter
}
