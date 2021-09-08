import Combine
import SwiftUI

// MARK: - ARWaterSurfaceView
struct ARWaterSurfaceView: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  static let height = CGFloat(188)
  static let depthsViewPlusSliderHeight = CGFloat(128)
  
  // MARK: property
  
  @Environment(\.colorScheme) var colorScheme
  @Binding var waterSurface: Double
  @Binding var depthUnit: BathymetryDepthUnit
  
  let top: Double
  let bottom: Double
  
  let sliderHeight = CGFloat(128)
  var sliderOffsetY: CGFloat {
    sliderHeight + depthTextOffsetY + depthTextFontSize + textOffset
  }
  let textOffset = CGFloat(8)
  let waterSurfaceTextFontSize = CGFloat(8)
  let waterSurfaceTextOffsetY = CGFloat(12)
  let depthTextFontSize = CGFloat(16)
  var depthTextOffsetY: CGFloat {
    waterSurfaceTextOffsetY + waterSurfaceTextFontSize + 4
  }
  
  var body: some View {
    ZStack {
      GeometryReader { _ in
        backgroundView
        slider
        waterSurfaceText
        depthText
      }
    }
  }
  
  var backgroundView: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(width: ARWaterSurfaceView.width, height: ARWaterSurfaceView.height)
      .foregroundColor(colorScheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
  }
  
  var slider: some View {
    CustomSlider(
      value: $waterSurface,
      in: bottom...top,
      minimumTrackTintColor: Color(red: 110.0 / 255.0, green: 171.0 / 255.0, blue: 197.0 / 255.0, opacity: 1.0),
      thumbImage: UIImage(named: "bathymetry_slider-thumb")
    )
    .frame(width: sliderHeight, height: ARWaterSurfaceView.width)
    .rotationEffect(.degrees(270), anchor: .topLeading)
    .offset(x: 0, y: sliderOffsetY)
  }
  
  var waterSurfaceText: some View {
    Text("Water Surface")
      .frame(
        maxWidth: ARWaterSurfaceView.width,
        alignment: .center
      )
      .font(.system(size: waterSurfaceTextFontSize))
      .offset(x: 0, y: waterSurfaceTextOffsetY)
  }
  
  var depthText: some View {
    Text(
      String(
        format: "%.1f\(depthUnit.abbr)",
        depthUnit == .meter ? waterSurface.meter : waterSurface.feet
      )
    )
      .frame(
        maxWidth: ARWaterSurfaceView.width,
        alignment: .center
      )
      .font(.system(size: depthTextFontSize))
      .offset(x: 0, y: depthTextOffsetY)
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
