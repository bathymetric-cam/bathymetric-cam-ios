import SwiftUI

// MARK: - BathymetryWaterSurfaceSlider
struct BathymetryWaterSurfaceSlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(256)
  static let sliderHeight = CGFloat(128)
  
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
            get: { 4 },
            set: { _ in }
          ),
          height: Binding<CGFloat>(
            get: { BathymetryWaterSurfaceSlider.height - BathymetryWaterSurfaceSlider.sliderHeight * CGFloat((-0.5 - waterSurface) / (-0.5 + 15.0)) },
            set: { _ in }
          )
        )
        .offset(x: BathymetryWaterSurfaceSlider.width / 2.0 - 4 / 2.0, y: BathymetryWaterSurfaceSlider.sliderHeight * CGFloat((-0.5 - waterSurface) / (-0.5 + 15.0)))
        
        Text(String(format: "%.1f", waterSurface))
          .frame(
            maxWidth: BathymetryWaterSurfaceSlider.width,
            alignment: .center
          )
          .offset(x: 0, y: -24.0)
        
        CustomSlider(
          value: $waterSurface,
          in: (-15.0)...(-0.5),
          minimumTrackTintColor: .clear,
          thumbImage: UIImage(named: "bathymetry_slider-thumb")
        )
        .frame(width: BathymetryWaterSurfaceSlider.sliderHeight, height: BathymetryWaterSurfaceSlider.width)
        .rotationEffect(.degrees(270), anchor: .topLeading)
        .offset(x: 0, y: BathymetryWaterSurfaceSlider.sliderHeight)
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
