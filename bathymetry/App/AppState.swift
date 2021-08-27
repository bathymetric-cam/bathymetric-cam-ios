import CoreLocation
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
  // MARK: property
  
  var bathymetryTiles = [BathymetryTile]()
  var bathymetries: [Bathymetry]
  var zoomLevel = BathymetryZoomLevel.max
  var region = try? BathymetryRegion(
    swTile: BathymetryTile(x: 0, y: 0, zoom: Int(BathymetryZoomLevel.max)),
    neTile: BathymetryTile(x: 0, y: 0, zoom: Int(BathymetryZoomLevel.max))
  )
  var arIsOn = true
  var waterSurface = -1.5
  var depthUnit: BathymetryDepthUnit = .meter
}
