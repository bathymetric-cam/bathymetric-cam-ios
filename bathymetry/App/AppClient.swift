import ComposableArchitecture
import GEOSwift

// MARK: - AppClient Interface
struct AppClient {
    // MARK: - property
    
    var loadGeoJSON: () -> Effect<GeoJSON, Failure>
    
    // MARK: - Failure

    struct Failure: Error, Equatable {}
}

// MARK: - AppClient Implementation
extension AppClient {
    // MARK: - property
    
    static let live = AppClient(
        loadGeoJSON: {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "firebasestorage.googleapis.com"
            // components.path = "/v0/b/bathymetric-cam.appspot.com/o/countries.geojson"
            components.path = "/v0/b/bathymetric-cam.appspot.com/o/depth.geojson"
            components.queryItems = [
                URLQueryItem(name: "alt", value: "media"),
                // URLQueryItem(name: "token", value: "b48ca281-c969-4166-8440-91c2b3bc8382"),
                URLQueryItem(name: "token", value: "006f71f2-e222-45fb-bdaf-79063922871a"),
            ]
            guard let url = components.url else {
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
