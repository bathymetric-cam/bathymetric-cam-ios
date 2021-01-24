import Combine
import SwiftUI

// MARK: - MapView
protocol MapView: UIViewRepresentable {
    // MARK: - property
    
    var bathymetryTiles: [BathymetryTile] { get }
    var regionDidChangePublisher: PassthroughSubject<Region, Never> { get }
    
    // MARK: - MapView
    
    /// Called when map region did change
    /// - Parameter action: action closure
    /// - Returns: View
    associatedtype MapView
    func regionDidChange(perform action: @escaping (_ region: Region) -> Void) -> MapView
}

// MARK: - UIMapViewFactory
protocol UIMapViewFactory {
    /// Abstruct factory method
    /// - Returns: created factory
    static func createMapView() -> UIMapView
}

// MARK: - UIMapViewFactory
typealias UIMapView = UIView
