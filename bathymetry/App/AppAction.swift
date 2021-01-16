import ComposableArchitecture
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
    case loadBathymetries
    case bathymetriesResult(Result<[Bathymetry], BathymetryClient.Failure>)
    case bathymetryTilesUpdated(bathymetryTiles: [BathymetryTile])
}
