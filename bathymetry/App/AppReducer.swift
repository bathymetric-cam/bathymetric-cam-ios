import ComposableArchitecture
import GEOSwift

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case let .loadBathymetries(region):
        if let r = state.region, r.contains(region: region) {
            return .none
        }
        let doubled = region.doubled()
        state.region = doubled
        return environment.bathymetryClient
            .loadBathymetries(doubled)
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
