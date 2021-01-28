import Combine
import SwiftUI

// MARK: - MapView
struct MapView: UIViewRepresentable {
    
    // MARK: property
    
    let internalMapView: UIMapView
    @Binding var bathymetryTiles: [BathymetryTile]
    let regionDidChangePublisher = PassthroughSubject<Region, Never>()
    
    // MARK: UIViewRepresentable
    
    static func dismantleUIView(_ uiView: MapView.UIViewType, coordinator: MapView.Coordinator) {
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: public api
    
    func regionDidChange(perform action: @escaping (_ region: Region) -> Void) -> some View {
        onReceive(regionDidChangePublisher) { action($0) }
    }
}

// MARK: - UIMapViewFactory
protocol UIMapViewFactory {
    /// Abstruct factory method
    /// - Returns: created factory
    static func createMapView() -> UIMapView
}

// MARK: - UIMapViewFactory
typealias UIMapView = UIView
