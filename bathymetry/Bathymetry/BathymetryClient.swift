import ComposableArchitecture
import Combine

// MARK: - BathymetryClient Interface
struct BathymetryClient {
    // MARK: property
    
    var loadBathymetries: (_ region: Region) -> Effect<[BathymetryTile], Failure>
    
    // MARK: Failure

    struct Failure: Error, Equatable {}
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
    func loadBathymetries(region: Region, promise: @escaping (Result<[BathymetryTile], BathymetryClient.Failure>) -> Void)
}
