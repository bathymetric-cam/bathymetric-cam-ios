import ComposableArchitecture
import GEOSwift

// MARK: - AppAction
enum AppAction: Equatable {
    case loadGeoJSON
    case geoJSONResult(Result<GeoJSON, AppClient.Failure>)
}
