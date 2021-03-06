import SwiftUI

// MARK: - BathymetryDepthsView
struct BathymetryDepthsView: View {
  
  // MARK: property
  
  @Binding var bathymetries: [Bathymetry]
  @Binding var depthUnit: BathymetryDepthUnit
  @Binding var width: CGFloat
  @Binding var height: CGFloat
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(bathymetries, id: \.self) {
        BathymetryDepthView(bathymetry: $0, depthUnit: depthUnit, width: width, height: height / CGFloat(bathymetries.count))
      }
    }
  }
}

// MARK: - BathymetryDepthView
struct BathymetryDepthView: View {
  
  // MARK: property
  
  let bathymetry: Bathymetry
  let depthUnit: BathymetryDepthUnit
  let width: CGFloat
  let height: CGFloat
  
  var body: some View {
    HStack(alignment: .bottom) {
      Rectangle()
        .fill(bathymetry.color)
        .frame(width: width, height: height)
      Text(String(format: "%.1f", depthUnit == .meter ? bathymetry.depth.max.meter : bathymetry.depth.max.feet))
        .frame(alignment: .trailing)
        .font(.system(size: 8))
    }
  }
}

// MARK: - BathymetryDepthsView_Previews
struct BathymetryDepthsView_Previews: PreviewProvider {
  static var previews: some View {
    BathymetryDepthsView(
      bathymetries: Binding<[Bathymetry]>(
        get: { .default },
        set: { _ in }
      ),
      depthUnit: Binding<BathymetryDepthUnit>(
        get: { .meter },
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
