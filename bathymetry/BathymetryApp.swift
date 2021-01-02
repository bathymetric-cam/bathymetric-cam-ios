import ComposableArchitecture
import SwiftUI

// MARK: - BathymetryApp
@main
struct BathymetryApp: App {
    
    let appView = AppView(store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            bathymetryClient: BathymetryClient.live
        )
    ))
    
    var body: some Scene {
        WindowGroup {
            appView
        }
    }
}
