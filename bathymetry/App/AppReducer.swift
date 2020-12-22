import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadGeoJSON:
        var featureCollection: FeatureCollection?
        if let geoJSONURL = Bundle.main.url(forResource: "DepthContour", withExtension: "geojson"),
            let data = try? Data(contentsOf: geoJSONURL),
            let geoJSON = try? JSONDecoder().decode(GeoJSON.self, from: data),
            case let .featureCollection(value) = geoJSON {
            featureCollection = value
        }
        return environment.geoJSON(featureCollection)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.geoJSONResult)
    case .geoJSONResult(.success):
        return .none
    case .geoJSONResult(.failure):
        return .none
  }
}
