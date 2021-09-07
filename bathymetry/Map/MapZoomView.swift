import Combine
import SwiftUI

// MARK: - MapZoomView
struct MapZoomView: View {
  // MARK: property
  
  @Binding var zoomLevel: BathymetryZoomLevel
  private let tapPublisher = PassthroughSubject<MapZoomButton.ZoomType, Never>()
  
  var body: some View {
    VStack {
      MapZoomButton(
        type: .zoomIn,
        zoomLevel: $zoomLevel
      )
      .onTap {
        tapPublisher.send(.zoomIn)
      }
      MapZoomButton(
        type: .zoomOut,
        zoomLevel: $zoomLevel
      )
      .onTap {
        tapPublisher.send(.zoomOut)
      }
    }
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping (MapZoomButton.ZoomType) -> Void) -> some View {
    onReceive(tapPublisher) { action($0) }
  }
}

// MARK: - MapZoomButtonView_Previews
struct MapZoomButtonView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      MapZoomView(zoomLevel: Binding<BathymetryZoomLevel>(
        get: { .max },
        set: { _ in }
      ))
        .colorScheme(colorScheme)
    }
  }
}
