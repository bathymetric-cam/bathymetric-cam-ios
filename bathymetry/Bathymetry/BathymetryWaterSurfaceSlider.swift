import SwiftUI

// MARK: - BathymetrySlider
struct BathymetrySlider: View {
  
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
        bathymetryDepthsView
        slider
        labels
      }
    }
  }
  
  var backgroundView: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(width: BathymetrySlider.width, height: BathymetrySlider.height)
      .foregroundColor(colorScheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
      .offset(y: -40)
  }
  
  var bathymetryDepthsView: some View {
    BathymetryDepthsView(
      bathymetries: Binding<[Bathymetry]>(
        get: { .default },
        set: { _ in }
      ),
      width: Binding<CGFloat>(
        get: { 4 },
        set: { _ in }
      ),
      height: Binding<CGFloat>(
        get: { BathymetrySlider.colorsViewPlusSliderHeight - BathymetrySlider.sliderHeight * CGFloat((BathymetrySlider.maxSurface - waterSurface) / (BathymetrySlider.maxSurface - BathymetrySlider.minSurface)) },
        set: { _ in }
      )
    )
    .offset(x: BathymetrySlider.width / 2.0 - 4 / 2.0, y: BathymetrySlider.sliderHeight * CGFloat((BathymetrySlider.maxSurface - waterSurface) / (BathymetrySlider.maxSurface - BathymetrySlider.minSurface)))
  }
  
  var slider: some View {
    CustomSlider(
      value: $waterSurface,
      in: BathymetrySlider.minSurface...BathymetrySlider.maxSurface,
      minimumTrackTintColor: .clear,
      thumbImage: UIImage(named: "bathymetry_slider-thumb")
    )
    .frame(width: BathymetrySlider.sliderHeight, height: BathymetrySlider.width)
    .rotationEffect(.degrees(270), anchor: .topLeading)
    .offset(x: 0, y: BathymetrySlider.sliderHeight)
  }
  
  var labels: some View {
    ZStack {
      Text("Water Surface")
        .frame(
          maxWidth: BathymetrySlider.width,
          alignment: .center
        )
        .font(.system(size: 8))
        .offset(x: 0, y: -32)
      Text(String(format: "%.1fm", waterSurface))
        .frame(
          maxWidth: BathymetrySlider.width,
          alignment: .center
        )
        .font(.system(size: 16))
        .offset(x: 0, y: -20)
      Text("Under Water")
        .frame(
          maxWidth: BathymetrySlider.width,
          alignment: .center
        )
        .font(.system(size: 8))
        .offset(x: 0, y: BathymetrySlider.colorsViewPlusSliderHeight + 6)
    }
  }
}

// MARK: - BathymetrySlider_Previews
struct BathymetrySlider_Previews: PreviewProvider {
  
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      BathymetrySlider(
        waterSurface: Binding<Double>(
          get: { -1.5 },
          set: { _ in }
        )
      )
      .colorScheme($0)
    }
  }
}
