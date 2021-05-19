import SwiftUI

// MARK: - BathymetryWaterSurfaceSlider
struct BathymetryWaterSurfaceSlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(320)
  static let colorsViewPlusSliderHeight = CGFloat(256)
  static let sliderHeight = CGFloat(128)
  
  static let minSurface = -15.0
  static let maxSurface = -0.5
  
  // MARK: property
  
  @Environment(\.colorScheme) var colorScheme
  @Binding var waterSurface: Double
  
  var body: some View {
    ZStack {
      GeometryReader { _ in
        backgroundView
        bathymetryColorsView
        slider
        labels
      }
    }
  }
  
  var backgroundView: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(width: BathymetryWaterSurfaceSlider.width, height: BathymetryWaterSurfaceSlider.height)
      .foregroundColor(colorScheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
      .offset(y: -40)
  }
  
  var bathymetryColorsView: some View {
    BathymetryColorsView(
      bathymetries: Binding<[Bathymetry]>(
        get: { .default },
        set: { _ in }
      ),
      width: Binding<CGFloat>(
        get: { 4 },
        set: { _ in }
      ),
      height: Binding<CGFloat>(
        get: { BathymetryWaterSurfaceSlider.colorsViewPlusSliderHeight - BathymetryWaterSurfaceSlider.sliderHeight * CGFloat((BathymetryWaterSurfaceSlider.maxSurface - waterSurface) / (BathymetryWaterSurfaceSlider.maxSurface - BathymetryWaterSurfaceSlider.minSurface)) },
        set: { _ in }
      )
    )
    .offset(x: BathymetryWaterSurfaceSlider.width / 2.0 - 4 / 2.0, y: BathymetryWaterSurfaceSlider.sliderHeight * CGFloat((BathymetryWaterSurfaceSlider.maxSurface - waterSurface) / (BathymetryWaterSurfaceSlider.maxSurface - BathymetryWaterSurfaceSlider.minSurface)))
  }
  
  var slider: some View {
    CustomSlider(
      value: $waterSurface,
      in: BathymetryWaterSurfaceSlider.minSurface...BathymetryWaterSurfaceSlider.maxSurface,
      minimumTrackTintColor: .clear,
      thumbImage: UIImage(named: "bathymetry_slider-thumb")
    )
    .frame(width: BathymetryWaterSurfaceSlider.sliderHeight, height: BathymetryWaterSurfaceSlider.width)
    .rotationEffect(.degrees(270), anchor: .topLeading)
    .offset(x: 0, y: BathymetryWaterSurfaceSlider.sliderHeight)
  }
  
  var labels: some View {
    ZStack {
      Text("Water Surface")
        .frame(
          maxWidth: BathymetryWaterSurfaceSlider.width,
          alignment: .center
        )
        .font(.system(size: 8))
        .offset(x: 0, y: -32)
      Text(String(format: "%.1fm", waterSurface))
        .frame(
          maxWidth: BathymetryWaterSurfaceSlider.width,
          alignment: .center
        )
        .font(.system(size: 16))
        .offset(x: 0, y: -20)
      Text("Under Water")
        .frame(
          maxWidth: BathymetryWaterSurfaceSlider.width,
          alignment: .center
        )
        .font(.system(size: 8))
        .offset(x: 0, y: BathymetryWaterSurfaceSlider.colorsViewPlusSliderHeight + 6)
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
