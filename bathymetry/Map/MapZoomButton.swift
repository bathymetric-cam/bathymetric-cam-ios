import Combine
import SwiftUI

// MARK: - MapZoomButton
struct MapZoomButton: View {
  
  // MARK: enum
  
  enum ZoomType: Hashable {
    case zoomIn
    case zoomOut
  }
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(64)
  
  // MARK: property
  
  let type: ZoomType
  @Binding var zoomLevel: BathymetryZoomLevel
  let tapPublisher = PassthroughSubject<Void, Never>()
 
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
  
  // MARK: View
  
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
      .frame(width: MapZoomButton.width, height: MapZoomButton.height)
      .opacity(opacity)
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - MapZoomButtonZoomIn_Previews
struct MapZoomButton_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      ForEach([MapZoomButton.ZoomType.zoomIn, MapZoomButton.ZoomType.zoomOut], id: \.self) { zoomType in
        MapZoomButton(
          type: zoomType,
          zoomLevel: Binding<BathymetryZoomLevel>(
            get: { .max },
            set: { _ in }
          )
        )
        .colorScheme(colorScheme)
      }
    }
  }
}
