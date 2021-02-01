import Combine
import SwiftUI

// MARK: - MapView
struct MapView: UIViewRepresentable {
    
    // MARK: property
    let internalMapView: UIMapView
    let regionDidChangePublisher = PassthroughSubject<Region, Never>()
    
    @Binding var bathymetryTiles: [BathymetryTile]
    @Binding var bathymetryColors: BathymetryColors
    @Binding var zoomLevel: Double
    
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

// MARK: - MapView + ZoomLevel
extension MapView {
    // MARK: static constant
    enum ZoomLevel {
        static let min = 14.0
        static let max = 16.0
    }
    enum Zoom {
        static let zoomIn = 0.5
        static let zoomOut = -0.5
    }
}

// MARK: - UIMapViewFactory
protocol UIMapViewFactory {
    /// Abstruct factory method
    /// - Returns: created factory
    static func createMapView(zoomLevel: Double) -> UIMapView
}

// MARK: - UIMapViewFactory
typealias UIMapView = UIView
