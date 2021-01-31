import Combine
import SwiftUI

// MARK: - MapView
struct MapView: UIViewRepresentable {
    
    // MARK: property
    let internalMapView: UIMapView
    let regionDidChangePublisher = PassthroughSubject<Region, Never>()
    
    @Binding var bathymetryTiles: [BathymetryTile]
    @Binding var bathymetryColors: BathymetryColors
    @Binding var zoomLevel: ZoomLevel
    
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
    // MARK: enum
    enum ZoomLevel: Double {
        case min = 14.0
        case max = 16.0
    }
    
    enum Zoom: Double {
        case zoomIn = 0.5
        case zoomOut = -0.5
    }
}

// MARK: - UIMapViewFactory
protocol UIMapViewFactory {
    /// Abstruct factory method
    /// - Returns: created factory
    static func createMapView(zoomLevel: MapView.ZoomLevel) -> UIMapView
}

// MARK: - UIMapViewFactory
typealias UIMapView = UIView
