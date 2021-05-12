import CoreLocation
import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
  // MARK: property
  
  var bathymetryTiles = [BathymetryTile]()
  var bathymetryColors: BathymetryColors
  var zoomLevel = BathymetryZoomLevel.max
  var region = BathymetryRegion(
    swTile: RegionTile(x: 0, y: 0),
    neTile: RegionTile(x: 0, y: 0),
    zoom: Int(BathymetryZoomLevel.max)
  )
  var arIsOn = true
  var waterSurface = -1.5
}
