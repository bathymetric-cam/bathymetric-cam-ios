import SwiftUI

// MARK: - BathymetrySlider
struct BathymetrySlider: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(324)
  static let depthsViewPlusSliderHeight = CGFloat(256)
  
  // MARK: property
  
  @Environment(\.colorScheme) var colorScheme
  @Binding var waterSurface: Double
  
  let minSurface = -15.0
  let maxSurface = -0.5
  
  let sliderHeight = CGFloat(128)
  var depthsViewHeight: CGFloat {
    BathymetrySlider.depthsViewPlusSliderHeight - sliderHeight * CGFloat((maxSurface - waterSurface) / (maxSurface - minSurface))
  }
  var depthsViewOffsetY: CGFloat {
    sliderHeight * CGFloat((maxSurface - waterSurface) / (maxSurface - minSurface)) + depthTextOffsetY + depthTextFontSize + textOffset
  }
  var sliderOffsetY: CGFloat {
    sliderHeight + depthTextOffsetY + depthTextFontSize + textOffset
  }
  let textOffset = CGFloat(8)
  let waterSurfaceTextFontSize = CGFloat(8)
  let waterSurfaceTextOffsetY = CGFloat(8)
  let depthTextFontSize = CGFloat(16)
  var depthTextOffsetY: CGFloat {
    waterSurfaceTextOffsetY + waterSurfaceTextFontSize + 4
  }
  let underWaterTextFontSize = CGFloat(8)
  var underWaterTextOffsetY: CGFloat {
    BathymetrySlider.height - underWaterTextFontSize - textOffset
  }
  
  var body: some View {
    ZStack {
      GeometryReader { _ in
        backgroundView
        depthsView
        slider
        waterSurfaceText
        depthText
        underWaterText
      }
    }
  }
  
  var backgroundView: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(width: BathymetrySlider.width, height: BathymetrySlider.height)
      .foregroundColor(colorScheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
  }
  
  var depthsView: some View {
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
        get: { depthsViewHeight },
        set: { _ in }
      )
    )
    .offset(x: BathymetrySlider.width / 2.0 - 4 / 2.0, y: depthsViewOffsetY)
  }
  
  var slider: some View {
    CustomSlider(
      value: $waterSurface,
      in: minSurface...maxSurface,
      minimumTrackTintColor: .clear,
      thumbImage: UIImage(named: "bathymetry_slider-thumb")
    )
    .frame(width: sliderHeight, height: BathymetrySlider.width)
    .rotationEffect(.degrees(270), anchor: .topLeading)
    .offset(x: 0, y: sliderOffsetY)
  }
  
  var waterSurfaceText: some View {
    Text("Water Surface")
      .frame(
        maxWidth: BathymetrySlider.width,
        alignment: .center
      )
      .font(.system(size: waterSurfaceTextFontSize))
      .offset(x: 0, y: waterSurfaceTextOffsetY)
  }
  
  var depthText: some View {
    Text(String(format: "%.1fm", waterSurface))
      .frame(
        maxWidth: BathymetrySlider.width,
        alignment: .center
      )
      .font(.system(size: depthTextFontSize))
      .offset(x: 0, y: depthTextOffsetY)
  }
  
  var underWaterText: some View {
    Text("Under Water")
      .frame(
        maxWidth: BathymetrySlider.width,
        alignment: .center
      )
      .font(.system(size: underWaterTextFontSize))
      .offset(x: 0, y: underWaterTextOffsetY)
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
