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
        /*
        if case let .featureCollection(featureCollection) = geoJSON {
            state.bathymetryTiles = [BathymetryTile(zoom: 16, x: 57483, y: 25955, features: featureCollection.features)]
        }
        */
        return .none
    case let .geoJSONResult(.failure(error)):
        return .none
    case let .bathymetryTilesUpdated(bathymetryTiles):
        return .none
    }
}
