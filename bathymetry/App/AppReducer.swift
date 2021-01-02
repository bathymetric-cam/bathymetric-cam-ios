import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadGeoJSON:
        return environment.bathymetryClient
            .loadGeoJSON()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.geoJSONResult)
    case let .geoJSONResult(.success(geoJSON)):
        state.geoJSON = geoJSON
        return .none
    case let .geoJSONResult(.failure(error)):
        return .none
    case let .geoJSONUpdated(geoJSON):
        return .none
    }
}
