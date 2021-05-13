import SwiftUI

// MARK: - BathymetryWaterSurfaceSlider
struct BathymetryWaterSurfaceSlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(128)
  
  // MARK: property
  
  @Binding var waterSurface: Double
  
  var body: some View {
    ZStack {
      GeometryReader { metrics in
        BathymetryColorsView(
          bathymetryColors: Binding<BathymetryColors>(
            get: { .defaultColors },
            set: { _ in }
          ),
          width: Binding<CGFloat>(
            get: { 8 },
            set: { _ in }
          ),
          height: Binding<CGFloat>(
            get: { CGFloat(128.0 - 128.0 * (-0.5 - waterSurface) / (-0.5 + 15.0)) },
            set: { _ in }
          )
        )
        .offset(x: BathymetryWaterSurfaceSlider.width / 2.0 - 8 / 2.0, y: CGFloat(128.0 * (-0.5 - waterSurface) / (-0.5 + 15.0)))
        
        CustomSlider(
          value: $waterSurface,
          in: (-15.0)...(-0.5),
          minimumTrackTintColor: .clear,
          maximumTrackTintColor: .clear,
          thumbImage: UIImage(named: "bathymetry_slider-thumb")
        )
        .frame(width: BathymetryWaterSurfaceSlider.height, height: BathymetryWaterSurfaceSlider.width)
        .rotationEffect(.degrees(270), anchor: .topLeading)
        .offset(x: 0, y: BathymetryWaterSurfaceSlider.height)
      }
    }
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
