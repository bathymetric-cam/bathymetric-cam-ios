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
            geoJSON: { featureCollection in
                guard let featureCollection = featureCollection else {
                    return Effect(error: AppError())
                }
                return Effect(value: featureCollection)
            }
        )
    ))
    
    var body: some Scene {
        WindowGroup {
            appView
        }
    }
}
