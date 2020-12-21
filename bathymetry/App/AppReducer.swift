import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadGeoJSON:
        if let geoJSONURL = Bundle.main.url(forResource: "multipolygon", withExtension: "geojson"),
            let data = try? Data(contentsOf: geoJSONURL),
            let geoJSON = try? JSONDecoder().decode(GeoJSON.self, from: data) {
            return environment.geoJSON("", nil)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(AppAction.geoJSONResult)
        }
        return .none
    case .geoJSONResult(.success):
        return .none
    case .geoJSONResult(.failure):
        return .none
  }
}
