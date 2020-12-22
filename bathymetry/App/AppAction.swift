import ComposableArchitecture
import GEOSwift

// MARK: - AppAction
enum AppAction: Equatable {
    case loadGeoJSON
    case geoJSONResult(Result<GeoJSON, AppError>)
}

// MARK: - AppError
struct AppError: Error, Equatable {
}
