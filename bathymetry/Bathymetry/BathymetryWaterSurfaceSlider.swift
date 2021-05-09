import SwiftUI

// MARK: - BathymetryWaterSurfaceSlider
struct BathymetryWaterSurfaceSlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(160)
  
  // MARK: property
  
  @Binding var waterSurface: Double
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Slider(
        value: $waterSurface,
        in: (-10.5)...(-0.5)
      )
      .frame(width: BathymetryWaterSurfaceSlider.height, height: BathymetryWaterSurfaceSlider.width)
      .rotationEffect(.degrees(270), anchor: .topLeading)
      .offset(x: 0, y: BathymetryWaterSurfaceSlider.height)
    }
    .frame(width: BathymetryWaterSurfaceSlider.height, height: BathymetryWaterSurfaceSlider.width)
  }
}

// MARK: - BathymetryWaterSurfaceSlider_Previews
struct BathymetryWaterSurfaceSlider_Previews: PreviewProvider {
  
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      BathymetryWaterSurfaceSlider(
        waterSurface: Binding<Double>(
          get: { 0 },
          set: { _ in }
        )
      )
      .colorScheme($0)
    }
  }
}
