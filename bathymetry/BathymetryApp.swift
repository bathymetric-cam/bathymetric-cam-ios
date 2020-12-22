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
            geoJSON: { json in
                guard let json = json else {
                    return Effect(error: AppError())
                }
                return Effect(value: json)
            }
        )
    ))
    
    var body: some Scene {
        WindowGroup {
            appView
        }
    }
}
