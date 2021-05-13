import SwiftUI

// MARK: - BathymetryColorsView
struct BathymetryColorsView: View {
  
  // MARK: property
  
  @Binding var bathymetryColors: BathymetryColors
  @Binding var width: CGFloat
  @Binding var height: CGFloat
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(bathymetryColors, id: \.self) {
        BathymetryColorView(bathymetryColor: $0, width: width, height: height / CGFloat(bathymetryColors.count))
      }
    }
  }
}

// MARK: - BathymetryColorView
struct BathymetryColorView: View {
  
  // MARK: property
  
  let bathymetryColor: BathymetryColor
  let width: CGFloat
  let height: CGFloat
  
  var body: some View {
    HStack(alignment: .bottom) {
      Rectangle()
        .fill(bathymetryColor.color)
        .frame(width: width, height: height)
    }
  }
}

// MARK: - BathymetryColorsView_Previews
struct BathymetryColorsView_Previews: PreviewProvider {
  static var previews: some View {
    BathymetryColorsView(
      bathymetryColors: Binding<BathymetryColors>(
        get: { .defaultColors },
        set: { _ in }
      ),
      width: Binding<CGFloat>(
        get: { 16 },
        set: { _ in }
      ),
      height: Binding<CGFloat>(
        get: { 128 },
        set: { _ in }
      )
    )
  }
}
