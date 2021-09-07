import Combine
import SwiftUI

// MARK: - ARWaterSurfaceButton
struct ARWaterSurfaceButton: View {
  
  // MARK: enum
  
  enum ButtonType: Hashable {
    case up
    case down
  }
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(64)
  
  // MARK: property
  
  let type: ButtonType
  let top: Double
  let bottom: Double
  @Binding var waterSurface: Double
  private let tapPublisher = PassthroughSubject<Void, Never>()
  
  var body: some View {
    CircularButton(
      background: Color(.systemBackground),
      foreground: Color(.label),
      action: { tapPublisher.send() },
      content: {
        Group {
          switch type {
          case .up:
            up
          case .down:
            down
          }
        }
      }
    )
      .frame(width: ARWaterSurfaceButton.width, height: ARWaterSurfaceButton.height)
      .opacity(opacity)
  }
  
  var up: some View {
    Image(
      systemName: "chevron.up"
    )
      .font(.title)
      .padding(.vertical, 6)
  }
  
  var down: some View {
    Image(
      systemName: "chevron.down"
    )
      .font(.title)
      .padding(.vertical, 6)
  }
  
  var opacity: Double {
    let val = (type == .up && waterSurface < top) || (type == .down && waterSurface > bottom) ? 1.0 : 0.5
    print(waterSurface)
    return val
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping () -> Void) -> some View {
    onReceive(tapPublisher) { action() }
  }
}

// MARK: - ARWaterSurfaceButton_Previews
struct ARWaterSurfaceButton_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      ForEach([ARWaterSurfaceButton.ButtonType.up, ARWaterSurfaceButton.ButtonType.down], id: \.self) { buttonType in
        ARWaterSurfaceButton(
          type: buttonType,
          top: -0.5,
          bottom: -15.0,
          waterSurface: Binding<Double>(
            get: { -0.5 },
            set: { _ in }
          )
        )
        .colorScheme(colorScheme)
      }
    }
  }
}
