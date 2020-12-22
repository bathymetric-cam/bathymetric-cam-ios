import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadGeoJSON:
        var json: GeoJSON?
        if let geoJSONURL = Bundle.main.url(forResource: "DepthContour", withExtension: "geojson"),
            let data = try? Data(contentsOf: geoJSONURL),
            let result = try? JSONDecoder().decode(GeoJSON.self, from: data) {
            json = result
        }
        return environment.geoJSON(json)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.geoJSONResult)
    case .geoJSONResult(.success):
        return .none
    case .geoJSONResult(.failure):
        return .none
  }
}
