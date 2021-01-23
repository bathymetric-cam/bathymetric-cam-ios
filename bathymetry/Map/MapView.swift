import Combine
import SwiftUI

// MARK: - UIMapView
protocol UIMapView {
}

// MARK: - MapView
protocol MapView: UIViewRepresentable {
    // MARK: - property
    
    var bathymetryTiles: [BathymetryTile] { get }
    var regionDidChangePublisher: PassthroughSubject<Region, Never> { get }
    
    /// Called when map region did change
    /// - Parameter action: action closure
    /// - Returns: View
    associatedtype MapView
    func regionDidChange(perform action: @escaping (_ region: Region) -> Void) -> MapView
}
