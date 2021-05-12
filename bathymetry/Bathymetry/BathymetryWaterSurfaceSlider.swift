import SwiftUI

// MARK: - BathymetryWaterSurfaceSlider
struct BathymetryWaterSurfaceSlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(128)
  
  // MARK: property
  
  @Binding var waterSurface: Double
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(String(format: "%.1f", waterSurface))
        .frame(
          maxWidth: BathymetryWaterSurfaceSlider.width,
          alignment: .center
        )
      CustomSlider(
        value: $waterSurface,
        in: (-15.0)...(-0.5),
        tintColor: .init(red: 0.0 / 255, green: 70.0 / 255, blue: 98.0 / 255),
        thumbImage: UIImage(named: "bathymetry_slider-thumb"),
        thresholdValue: 0.25,
        thresholdSecond: 0.25
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
          get: { -1.5 },
          set: { _ in }
        )
      )
      .colorScheme($0)
    }
  }
}
