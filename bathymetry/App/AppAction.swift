import ComposableArchitecture

// MARK: - AppAction
enum AppAction: Equatable {
  case loadGeoJSON
  case geoJSONResult(Result<String, AppError>)
}

// MARK: - AppError
struct AppError: Error, Equatable {
}
