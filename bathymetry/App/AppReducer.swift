import ComposableArchitecture

// MARK: - AppReducer
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .loadGeoJson:
    return .none
  }
}
