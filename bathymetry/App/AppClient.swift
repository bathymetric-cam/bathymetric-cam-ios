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
            guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bathymetric-cam.appspot.com/o/countries.geojson?alt=media&token=b48ca281-c969-4166-8440-91c2b3bc8382") else {
                return Effect(error: Failure())
            }
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .decode(type: GeoJSON.self, decoder: JSONDecoder())
                .mapError { _ in return Failure() }
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
