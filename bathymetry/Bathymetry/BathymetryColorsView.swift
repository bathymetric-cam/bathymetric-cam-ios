import SwiftUI

// MARK: - BathymetryColorsView
struct BathymetryColorsView: View {
  
  // MARK: static constant
  
  static let width = CGFloat(64)
  
  // MARK: property
  
  @Binding var bathymetryColors: BathymetryColors
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(bathymetryColors, id: \.self) {
        BathymetryColorView(bathymetryColor: $0)
      }
    }
  }
}

// MARK: - BathymetryColorView
struct BathymetryColorView: View {
  
  // MARK: property
  
  let bathymetryColor: BathymetryColor
  
  var body: some View {
    HStack(alignment: .bottom) {
      Rectangle()
        .fill(bathymetryColor.color)
        .frame(width: 32, height: 32)
      Text(String(format: "%.1f", bathymetryColor.depth.max))
        .frame(width: 32, alignment: .trailing)
        .font(.caption)
    }
    .frame(width: 64)
  }
}

// MARK: - BathymetryColorsView_Previews
struct BathymetryColorsView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach([ColorScheme.dark, ColorScheme.light], id: \.self) {
      Group {
        BathymetryColorsView(
          bathymetryColors: Binding<BathymetryColors>(
            get: { .defaultColors },
            set: { _ in }
          )
        )
      }
      .colorScheme($0)
    }
  }
}
