import ComposableArchitecture
import Combine
import Contentful

// MARK: - BathymetryClient Interface
struct BathymetryClient {
    // MARK: - property
    
    var loadBathymetries: () -> Effect<[Bathymetry], Failure>
    
    // MARK: - Failure

    struct Failure: Error, Equatable {}
}

// MARK: - BathymetryClient Implementation
extension BathymetryClient {
    // MARK: - property

    static let live = BathymetryClient(
        loadBathymetries: {
            Future<[Bathymetry], Failure> { promise in
                guard let path = Bundle.main.path(forResource: "Contentful-Info", ofType: "plist"),
                   let plist = NSDictionary(contentsOfFile: path),
                   let spaceId = plist["spaceId"] as? String,
                   let accessToken = plist["accessToken"] as? String else {
                    promise(.failure(Failure()))
                    return
                }
                let client = Client(spaceId: spaceId, accessToken: accessToken, contentTypeClasses: [Bathymetry.self])
                let query = QueryOn<Bathymetry>
                    .where(field: .zoom, .equals("16"))
                    .where(field: .x, .isGreaterThanOrEqualTo("57483"))
                    .where(field: .x, .isLessThanOrEqualTo("57483"))
                    .where(field: .y, .isGreaterThanOrEqualTo("25955"))
                    .where(field: .y, .isLessThanOrEqualTo("25955"))
                client.fetchArray(of: Bathymetry.self, matching: query) {
                    guard case let .success(result) = $0 else {
                        promise(.failure(Failure()))
                        return
                    }
                    promise(.success(result.items))
                }
            }
            .eraseToEffect()
        }
    )
}

// MARK: - BathymetryClient Mock
extension BathymetryClient {
    // MARK: - property
    
    static func mock(
        loadBathymetries: @escaping () -> Effect<[Bathymetry], Failure> = {
        fatalError("Unmocked")
    }) -> Self {
        Self(loadBathymetries: loadBathymetries)
    }
}
