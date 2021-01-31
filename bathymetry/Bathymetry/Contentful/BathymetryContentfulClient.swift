import Combine
import Contentful
import Foundation

// MARK: - BathymetryContentfulClientFactory
internal class BathymetryContentfulClientFactory: BathymetryInternalClientFactory {
    static func createClient() -> BathymetryInternalClient? {
        guard let path = Bundle.main.path(forResource: "Contentful-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let spaceId = plist["spaceId"] as? String,
           let accessToken = plist["accessToken"] as? String else {
            return nil
        }
        return BathymetryContentfulClient(
            spaceId: spaceId,
            accessToken: accessToken,
            contentTypeClasses: [BathymetryContentfulEntity.self]
        )
    }
}

// MARK: - BathymetryContentfulClient
internal class BathymetryContentfulClient: Client, BathymetryInternalClient {
    
    // MARK: - property
    
    private var previousTask: URLSessionDataTask?
    
    // MARK: - public api
    
    func loadBathymetries(region: Region, promise: @escaping (Result<[BathymetryTile], BathymetryClient.Failure>) -> Void) {
        previousTask?.cancel()
        
        let query = QueryOn<BathymetryContentfulEntity>
            .where(field: .zoom, .equals("\(region.swTile.zoom)"))
            .where(field: .x, .isGreaterThanOrEqualTo("\(region.swTile.x)"))
            .where(field: .x, .isLessThanOrEqualTo("\(region.neTile.x)"))
            .where(field: .y, .isGreaterThanOrEqualTo("\(region.neTile.y)"))
            .where(field: .y, .isLessThanOrEqualTo("\(region.swTile.y)"))
        previousTask = fetchArray(of: BathymetryContentfulEntity.self, matching: query) {
            guard case let .success(result) = $0 else {
                promise(.failure(BathymetryClient.Failure()))
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
}

// MARK: - BathymetryClient+Contentful
extension BathymetryClient {
    // MARK: static constant

    static let contentful = BathymetryClient { region in
        Future<[BathymetryTile], Failure> { promise in
            guard let client = BathymetryContentfulClientFactory.createClient() else {
                promise(.failure(Failure()))
                return
            }
            client.loadBathymetries(region: region, promise: promise)
        }
        .eraseToEffect()
    }
}
