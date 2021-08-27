import ComposableArchitecture

// MARK: - AppReducer
// swiftlint:disable closure_body_length
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
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
