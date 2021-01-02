import ComposableArchitecture
import GEOSwift
import SwiftUI

// MARK: - AppAction
enum AppAction: Equatable {
    case loadGeoJSON
    case geoJSONResult(Result<GeoJSON, BathymetryClient.Failure>)
    case bathymetriesUpdated(bathymetries: [Bathymetry])
}
