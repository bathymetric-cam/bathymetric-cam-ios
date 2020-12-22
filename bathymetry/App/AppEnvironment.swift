import ComposableArchitecture
import GEOSwift

// MARK: - AppEnvironment
struct AppEnvironment {
    // MARK: - property
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var geoJSON: (FeatureCollection?) -> Effect<FeatureCollection, AppError>
}
