import Combine
import SwiftUI

// MARK: - ARWaterSurfaceView
struct ARWaterSurfaceView: View {
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(169)
      
  // MARK: property

  @Binding var waterSurface: Double
  @Binding var depthUnit: BathymetryDepthUnit
  let top: Double
  let bottom: Double
  private let tapPublisher = PassthroughSubject<Double, Never>()
  
  var body: some View {
    VStack {
      ARWaterSurfaceButton(
        type: .up,
        top: top,
        bottom: bottom,
        waterSurface: $waterSurface
      )
      .onTap { tapPublisher.send(waterSurface) }
      Text(String(format: "%.1f\(depthUnit.abbr)", depthUnit == .meter ? waterSurface.meter : waterSurface.feet))
        .frame(maxWidth: ARWaterSurfaceView.width, alignment: .center)
      ARWaterSurfaceButton(
        type: .down,
        top: top,
        bottom: bottom,
        waterSurface: $waterSurface
      )
      .onTap { tapPublisher.send(waterSurface) }
    }
  }
  
  // MARK: public api
  
  func onTap(perform action: @escaping (Double) -> Void) -> some View {
    onReceive(tapPublisher) { action($0) }
  }
}

// MARK: - ARWaterSurfaceView_Previews
struct ARWaterSurfaceView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) { colorScheme in
      ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { -0.5 },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .meter },
          set: { _ in }
        ),
        top: -0.5,
        bottom: -15.0
      )
        .colorScheme(colorScheme)
    }
  }
}
