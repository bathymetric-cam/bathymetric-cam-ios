import ComposableArchitecture
import Combine

// MARK: - BathymetryClient
struct BathymetryClient {
    // MARK: property
    
    var loadBathymetries: (_ region: BathymetryRegion) -> Effect<[BathymetryTile], Failure>
}

// MARK: - BathymetryInternalClientFactory
protocol BathymetryInternalClientFactory {
    /// Abstruct factory method
    /// - Returns: created factory
    static func createClient() -> BathymetryInternalClient?
}

// MARK: - BathymetryInternalClient
protocol BathymetryInternalClient {
    /// load Bathymetry array by the current map region
    /// - Parameters:
    ///   - region: Region
    ///   - promise: Result of the load
    func loadBathymetries(region: BathymetryRegion, promise: @escaping (Result<[BathymetryTile], BathymetryClient.Failure>) -> Void)
}
