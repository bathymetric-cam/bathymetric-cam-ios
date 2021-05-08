import ComposableArchitecture
import SwiftUI

// MARK: - BathymetryApp
@main
struct BathymetryApp: App {
  // MARK: property
  
  let appView = AppView(store: Store(
    initialState: AppState(bathymetryColors: .defaultColors),
    reducer: appReducer,
    environment: AppEnvironment(
      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
      bathymetryClient: BathymetryContentfulClient()
    )
  ))
  
  var body: some Scene {
    WindowGroup {
      appView
    }
  }
  
  // MARK: initializer
  
  init() {
  }
}
