import Combine
import ComposableArchitecture
import Contentful
import Foundation

// MARK: - BathymetryContentfulClient
class BathymetryContentfulClient: BathymetryClient {
  
  // MARK: property
  
  private let client = BathymetryContentfulInternalClient()
  
  // MARK: public api
  
  /// load bathymetry data from contentful
  /// - Parameter region: BathymetryRegion
  /// - Returns: Effect<[BathymetryTile], BathymetryClientFailure>
  func loadBathymetries(_ region: BathymetryRegion) -> Effect<[BathymetryTile], BathymetryClientFailure> {
    Deferred { [weak self] in
      Future<[BathymetryTile], BathymetryClientFailure> { [weak self] promise in
        self?.client.loadBathymetries(region: region, promise: promise)
      }
    }
    .eraseToEffect()
  }
}

// MARK: - BathymetryContentfulInternalClient
class BathymetryContentfulInternalClient: Client {
  // MARK: property
  
  private var urlSessionTasks = [URLSessionDataTask]()
  
  // MARK: initializer
  
  init() {
    guard let path = Bundle.main.path(forResource: "Contentful-Info", ofType: "plist") else {
      fatalError("Cannot open Contentful-Info.plist")
    }
    guard let plist = NSDictionary(contentsOfFile: path),
          let spaceId = plist["spaceId"] as? String,
          let accessToken = plist["accessToken"] as? String else {
      fatalError("Invalid Contentful-Info.plist")
    }
    super.init(spaceId: spaceId, accessToken: accessToken, contentTypeClasses: [BathymetryContentfulEntity.self])
  }
  
  deinit {
    cancelUrlSessionTasks()
  }
  
  // MARK: public api
  
  /// Loads bathymetry data from contentful API
  /// - Parameters:
  ///   - region: BathymetryRegion
  ///   - promise: closure called when succeeding or failing
  func loadBathymetries(region: BathymetryRegion, promise: @escaping (Result<[BathymetryTile], BathymetryClientFailure>) -> Void) {
    cancelUrlSessionTasks()
    let query = QueryOn<BathymetryContentfulEntity>
      .where(field: .zoom, .equals("\(region.zoom)"))
      .where(field: .x, .isGreaterThanOrEqualTo("\(region.swTile.x)"))
      .where(field: .x, .isLessThanOrEqualTo("\(region.neTile.x)"))
      .where(field: .y, .isGreaterThanOrEqualTo("\(region.neTile.y)"))
      .where(field: .y, .isLessThanOrEqualTo("\(region.swTile.y)"))
    let urlSessionTask = fetchArray(of: BathymetryContentfulEntity.self, matching: query) {
      if case let .failure(error) = $0 {
        promise(.failure(.otherFailure(error)))
        logger.error("\(logger.prefix(), privacy: .private)\(BathymetryClientFailure.otherFailure(error), privacy: .private)\(logger.suffix, privacy: .private)")
        return
      }
      guard case let .success(result) = $0 else {
        promise(.success([]))
        logger.debug("\(logger.prefix(), privacy: .private)\("Empty result", privacy: .private)\(logger.suffix, privacy: .private)")
        return
      }
      promise(.success(
        result.items.compactMap {
          guard let zoom = $0.zoom, let x = $0.x, let y = $0.y, let geoJSON = $0.geoJSON,
                case let .featureCollection(featureCollection) = geoJSON else {
            return nil
          }
          return BathymetryTile(x: x, y: y, zoom: zoom, features: featureCollection.features)
        }
      ))
    }
    urlSessionTasks.append(urlSessionTask)
  }
  
  // MARK: private api
  
  /// Cancel url session tasks
  private func cancelUrlSessionTasks() {
    urlSessionTasks = urlSessionTasks.compactMap {
      switch $0.state {
      case .running, .suspended:
        $0.cancel()
        return $0
      case .canceling:
        return $0
      default:
        return nil
      }
    }
  }
}
