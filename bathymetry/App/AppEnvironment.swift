import ComposableArchitecture

// MARK: - AppEnvironment
struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
}
