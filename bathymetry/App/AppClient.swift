import ComposableArchitecture
import GEOSwift

// MARK: - AppClient Interface
struct AppClient {
    // MARK: - property
    
    var loadGeoJSON: () -> Effect<GeoJSON, Failure>
    
    struct Failure: Error, Equatable {}
}

// MARK: - AppClient Implementation
extension AppClient {
    // MARK: - property
    
    static let live = AppClient(
        loadGeoJSON: {
            guard let url = URL(string: "https://bathymetric-cam.s3-us-west-2.amazonaws.com/depth.geojson") else {
                return Effect(error: Failure())
            }
            return URLSession.shared.dataTaskPublisher(for: url)
              .map { data, _ in data }
              .decode(type: GeoJSON.self, decoder: JSONDecoder())
              .mapError { _ in Failure() }
              .eraseToEffect()
        }
    )
}

// MARK: - AppClient Mock
extension AppClient {
    
    // MARK: - property
    static func mock(
    loadGeoJSON: @escaping () -> Effect<GeoJSON, Failure> = {
        fatalError("Unmocked")
    }) -> Self {
        Self(loadGeoJSON: loadGeoJSON)
    }
}
