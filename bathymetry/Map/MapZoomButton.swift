import Combine
import SwiftUI

// MARK: - MapZoomButton
struct MapZoomButton: View {
  
  // MARK: enum
  
  enum ZoomType {
    case zoomIn
    case zoomOut
  }
  
  // MARK: property
  
  let type: ZoomType
  @Binding var zoomLevel: BathymetryZoomLevel
  let tapPublisher = PassthroughSubject<Void, Never>()

  var body: some View {
    CircularButton(
      background: Color(.systemBackground),
      foreground: Color(.label),
      action: { tapPublisher.send() },
      content: {
        Group {
          if type == .zoomIn {
            zoomIn
          } else {
            zoomOut
          }
        }
      }
    )
      .frame(width: 64, height: 64)
      .opacity(opacity)
  }
  
  var zoomIn: some View {
    Image(
      systemName: "plus"
    )
      .font(.title)
      .padding(.horizontal, 1)
      .padding(.top, 3)
      .padding(.bottom, 2)
  }
  
  var zoomOut: some View {
    Image(
      systemName: "minus"
    )
      .font(.title)
      .padding(.vertical, 12)
      .padding(.horizontal, 1)
      .padding(.top, 1)
  }
  
  var opacity: Double {
    (type == .zoomIn && zoomLevel < .max) || (type == .zoomOut && zoomLevel > .min) ? 1.0 : 0.5
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - MapZoomButtonZoomIn_Previews
struct MapZoomButtonZoomIn_Previews: PreviewProvider {
  static var previews: some View {
    MapZoomButton(
      type: .zoomIn,
      zoomLevel: Binding<BathymetryZoomLevel>(
        get: { .max },
        set: { _ in }
      )
    )
  }
}

// MARK: - MapZoomButtonZoomOut_Previews
struct MapZoomButtonZoomOut_Previews: PreviewProvider {
  static var previews: some View {
    MapZoomButton(
      type: .zoomOut,
      zoomLevel: Binding<BathymetryZoomLevel>(
        get: { .max },
        set: { _ in }
      )
    )
  }
}
