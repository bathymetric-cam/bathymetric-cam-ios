import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .loadBathymetries:
        return environment.bathymetryClient
            .loadBathymetries()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.bathymetriesResult)
    case let .bathymetriesResult(.success(bathymetries)):
        state.bathymetryTiles = []
        bathymetries.forEach {
            if let zoom = $0.zoom,
                let x = $0.x,
                let y = $0.y,
                let geoJSON = $0.geoJSON,
                case let .featureCollection(featureCollection) = geoJSON {
                state.bathymetryTiles.append(BathymetryTile(zoom: zoom, x: x, y: y, features: featureCollection.features))
            }
        }
        return .none
    case let .bathymetriesResult(.failure(error)):
        return .none
    case let .bathymetryTilesUpdated(bathymetryTiles):
        return .none
    }
}
