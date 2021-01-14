import ComposableArchitecture
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
    case loadGeoJSON
    case geoJSONResult(Result<[Bathymetry], BathymetryClient.Failure>)
    case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
}
