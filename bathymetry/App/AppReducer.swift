import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case let .loadBathymetries(region):
        return environment.bathymetryClient
            .loadBathymetries(region)
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
    }
}
