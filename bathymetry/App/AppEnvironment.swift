import ComposableArchitecture

// MARK: - AppEnvironment
struct AppEnvironment {
    // MARK: - property
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var geoJSON: (String?, AppError?) -> Effect<String, AppError>
}
