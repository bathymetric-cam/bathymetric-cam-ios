import ComposableArchitecture
import CoreLocation
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
  case loadBathymetryTile(region: MapRegion)
  case bathymetryTileResult(Result<BathymetryTile, BathymetryTileClientError>)
  case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
  case bathymetriesUpdated(bathymetries: [Bathymetry])
  case zoomIn
  case zoomOut
  case zoomLevelUpdated(zoomLevel: BathymetryZoomLevel)
  case arIsOnToggled(Bool)
  case waterSurfaceUpdated(Double)
  case depthUnitUpdated(BathymetryDepthUnit)
}
