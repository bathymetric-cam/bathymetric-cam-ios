import ComposableArchitecture
import CoreLocation
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
    case loadBathymetries(Region)
    case bathymetriesResult(Result<[BathymetryTile], BathymetryClient.Failure>)
    case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
    case bathymetryColorsUpdated(bathymetryTiles: BathymetryColors)
    case zoomLevelUpdated(zoomLevel: MapView.ZoomLevel)
}
