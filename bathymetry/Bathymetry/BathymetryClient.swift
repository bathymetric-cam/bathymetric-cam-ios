import ComposableArchitecture
import Combine
import Contentful

// MARK: - BathymetryClient Interface
struct BathymetryClient {
    // MARK: - property
    
    var loadBathymetries: (_ region: Region) -> Effect<[BathymetryTile], Failure>
    
    // MARK: - Failure

    struct Failure: Error, Equatable {}
}

// MARK: - BathymetryClient Implementation
extension BathymetryClient {
    // MARK: - property

    static let live = BathymetryClient { region in
        Future<[BathymetryTile], Failure> { promise in
            guard let path = Bundle.main.path(forResource: "Contentful-Info", ofType: "plist"),
               let plist = NSDictionary(contentsOfFile: path),
               let spaceId = plist["spaceId"] as? String,
               let accessToken = plist["accessToken"] as? String else {
                promise(.failure(Failure()))
                return
            }
            let client = Client(spaceId: spaceId, accessToken: accessToken, contentTypeClasses: [Bathymetry.self])
            let query = QueryOn<Bathymetry>
                .where(field: .zoom, .equals("\(region.swTile.zoom)"))
                .where(field: .x, .isGreaterThanOrEqualTo("\(region.swTile.x)"))
                .where(field: .x, .isLessThanOrEqualTo("\(region.neTile.x)"))
                .where(field: .y, .isGreaterThanOrEqualTo("\(region.neTile.y)"))
                .where(field: .y, .isLessThanOrEqualTo("\(region.swTile.y)"))
            client.fetchArray(of: Bathymetry.self, matching: query) {
                guard case let .success(result) = $0 else {
                    promise(.failure(Failure()))
                    return
                }
                var bathymetryTiles: [BathymetryTile] = []
                result.items.forEach {
                    if let zoom = $0.zoom,
                        let x = $0.x,
                        let y = $0.y,
                        let geoJSON = $0.geoJSON,
                        case let .featureCollection(featureCollection) = geoJSON {
                        bathymetryTiles.append(BathymetryTile(x: x, y: y, zoom: zoom, features: featureCollection.features))
                    }
                }
                promise(.success(bathymetryTiles))
            }
        }
        .eraseToEffect()
    }
}

// MARK: - BathymetryClient Mock
extension BathymetryClient {
    // MARK: - property
    
    static func mock(
        loadBathymetries: @escaping (_ region: Region) -> Effect<[BathymetryTile], Failure> = { _ in
        fatalError("Unmocked")
    }) -> Self {
        Self(loadBathymetries: loadBathymetries)
    }
}
