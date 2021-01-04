import ComposableArchitecture
import Firebase
import os
import SwiftUI

let logger = Logger(subsystem: "\(Bundle.main.bundleIdentifier ?? "").logger", category: "main")

// MARK: - BathymetryApp
@main
struct BathymetryApp: App {
    // MARK: - property
    
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
    
    // MARK: - initialization
    
    init() {
        FirebaseApp.configure()
    }
}
