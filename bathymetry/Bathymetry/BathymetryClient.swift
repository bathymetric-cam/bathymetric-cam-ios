import ComposableArchitecture
import GEOSwift

// MARK: - BathymetryClient Interface
struct BathymetryClient {
    // MARK: - property
    
    var loadGeoJSON: () -> Effect<GeoJSON, Failure>
    
    // MARK: - Failure

    struct Failure: Error, Equatable {}
}

// MARK: - BathymetryClient Implementation
extension BathymetryClient {
    // MARK: - property

    static let live = BathymetryClient(
        loadGeoJSON: {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "firebasestorage.googleapis.com"
            components.path = "/v0/b/bathymetric-cam.appspot.com/o/depth.geojson"
            components.queryItems = [
                URLQueryItem(name: "alt", value: "media"),
                URLQueryItem(name: "token", value: "4be6b1f3-b365-45be-9d87-3d262279c1bf"),
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

// MARK: - BathymetryClient Mock
extension BathymetryClient {
    // MARK: - property
    
    static func mock(
        loadGeoJSON: @escaping () -> Effect<GeoJSON, Failure> = {
        fatalError("Unmocked")
    }) -> Self {
        Self(loadGeoJSON: loadGeoJSON)
    }
}
