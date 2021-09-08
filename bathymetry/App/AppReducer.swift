import ComposableArchitecture

// MARK: - AppReducer
// swiftlint:disable closure_body_length
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case let .loadBathymetryTile(region):
    guard let region = region, !(state.region?.contains(region: region) ?? false) else {
      return .none
    }
    state.region = try? region.bathymetryRegion(times: 2.0)
    return environment.bathymetryTileClient
      .loadBathymetryTile(region: state.region ?? region)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(AppAction.bathymetryTileResult)
  case let .bathymetryTileResult(.success(tile)):
    if !state.bathymetryTiles.contains(tile) {
      state.bathymetryTiles.append(tile)
    }
    return .none
  case let .bathymetryTileResult(.failure(error)):
    return .none
  case let .bathymetryTilesUpdated(bathymetryTiles):
    return .none
  case let .bathymetriesUpdated(bathymetries):
    return .none
  case .zoomIn:
    state.zoomLevel.zoomIn()
    return .none
  case .zoomOut:
    state.zoomLevel.zoomOut()
    return .none
  case let .zoomLevelUpdated(zoomLevel):
    return .none
  case let .arIsOnToggled(arIsOn):
    state.arIsOn = arIsOn
    return .none
  case let .waterSurfaceUpdated(waterSurface):
    state.waterSurface = waterSurface
    return .none
  case let .depthUnitUpdated(depthUnit):
    state.depthUnit = depthUnit
    return .none
  }
}
// swiftlint:enable closure_body_length
