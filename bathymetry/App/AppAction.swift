import ComposableArchitecture
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
    case loadBathymetries(region: Region)
    case bathymetriesResult(Result<[Bathymetry], BathymetryClient.Failure>)
    case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
}
