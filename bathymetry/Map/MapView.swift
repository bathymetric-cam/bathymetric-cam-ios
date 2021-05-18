import Combine
import SwiftUI

// MARK: - MapView
struct MapView: UIViewRepresentable {
  
  // MARK: property
  let internalMapView: UIMapView
  let regionDidChangePublisher = PassthroughSubject<BathymetryRegion, Never>()
  
  @Binding var bathymetryTiles: [BathymetryTile]
  @Binding var bathymetryColors: BathymetryColors
  @Binding var zoomLevel: BathymetryZoomLevel
  
  // MARK: UIViewRepresentable
  
  static func dismantleUIView(_ uiView: MapView.UIViewType, coordinator: MapView.Coordinator) {
  }
  
  func makeCoordinator() -> MapView.Coordinator {
    Coordinator(self)
  }
  
  // MARK: public api
  
  func regionDidChange(perform action: @escaping (_ region: BathymetryRegion) -> Void) -> some View {
    onReceive(regionDidChangePublisher) { action($0) }
  }
}

// MARK: MapViewModifier
struct MapViewModifier: ViewModifier {
  // MARK: property

  let metrics: GeometryProxy

  // MARK: public api

  func body(content: Content) -> some View {
    content
      .frame(
        width: metrics.size.width,
        height: metrics.size.width
      )
      .cornerRadius(metrics.size.width / 2.0)
      .offset(y: metrics.size.height - metrics.size.width / 2.0)
      .overlay(
        RoundedRectangle(cornerRadius: metrics.size.width / 2.0)
          .stroke(Color.gray, lineWidth: 4)
          .offset(y: metrics.size.height - metrics.size.width / 2.0)
      )
  }
}

// MARK: - UIMapViewFactory
protocol UIMapViewFactory {
  /// Abstruct factory method
  /// - Returns: created factory
  static func createMapView(zoomLevel: BathymetryZoomLevel) -> UIMapView
}

// MARK: - UIMapViewFactory
typealias UIMapView = UIView
