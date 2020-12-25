import ComposableArchitecture
import GEOSwift

// MARK: - AppEnvironment
struct AppEnvironment {
    // MARK: - property
    
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var appClient: AppClient
}
