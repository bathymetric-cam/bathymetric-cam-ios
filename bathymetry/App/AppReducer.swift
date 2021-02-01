import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case let .loadBathymetries(region):
        if state.region.contains(region: region) {
            return .none
        }
        state.region = region.largerRegion()
        return environment.bathymetryClient
            .loadBathymetries(state.region)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppAction.bathymetriesResult)
    case let .bathymetriesResult(.success(bathymetryTiles)):
        state.bathymetryTiles = bathymetryTiles
        return .none
    case let .bathymetriesResult(.failure(error)):
        return .none
    case let .bathymetryTilesUpdated(bathymetryTiles):
        return .none
    case let .bathymetryColorsUpdated(bathymetryColors):
        return .none
    case let .updateZoomLevel(value):
        state.zoomLevel += value
        return .none
    case let .zoomLevelUpdated(zoomLevel):
        return .none
    }
}
