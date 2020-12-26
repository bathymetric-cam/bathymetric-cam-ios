import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadGeoJSON:
        struct SearchLocationId: Hashable {}
        return environment.appClient
            .loadGeoJSON()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.geoJSONResult)
    case let .geoJSONResult(.success(json)):
        state.geoJSON = json
        return .none
    case let .geoJSONResult(.failure(error)):
        return .none
  }
}
