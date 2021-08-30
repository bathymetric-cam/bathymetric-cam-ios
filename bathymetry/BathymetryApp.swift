import ComposableArchitecture
import SwiftUI

// MARK: - BathymetryAppLoader
// swiftlint:disable convenience_type
@main
struct BathymetryAppLoader {
  static func main() throws {
    if NSClassFromString("XCTestCase") == nil {
      BathymetryApp.main()
    } else {
      BathymetryTestApp.main()
    }
  }
}
// swiftlint:enable convenience_type

// MARK: - BathymetryApp
struct BathymetryApp: App {
  // MARK: property
  
  let appView = AppView(store: Store(
    initialState: AppState(bathymetries: .default),
    reducer: appReducer,
    environment: AppEnvironment(
      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
      bathymetryTileClient: BathymetryTileAPIClient()
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

// MARK: - BathymetryTestApp
struct BathymetryTestApp: App {
  var body: some Scene {
    WindowGroup { Text("Running Tests") }
  }
}
