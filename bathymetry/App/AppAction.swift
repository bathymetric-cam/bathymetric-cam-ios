import ComposableArchitecture
import CoreLocation
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
  case loadBathymetries(BathymetryRegion)
  case bathymetriesResult(Result<[BathymetryTile], BathymetryClient.Failure>)
  case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
  case bathymetryColorsUpdated(bathymetryTiles: BathymetryColors)
  case zoomIn
  case zoomOut
  case zoomLevelUpdated(zoomLevel: BathymetryZoomLevel)
  case arIsOnChanged(Bool)
}
