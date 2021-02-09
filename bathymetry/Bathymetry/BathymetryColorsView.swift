import SwiftUI

// MARK: - BathymetryColorsView
struct BathymetryColorsView: View {
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
                .frame(width: 40, height: 40)
            Text(String(format: "%.1f", bathymetryColor.depth.max))
                .frame(width: 40)
        }
        .frame(width: 80)
    }
}

// MARK: - BathymetryColorsView_Previews
struct BathymetryColorsView_Previews: PreviewProvider {
    static var previews: some View {
        BathymetryColorsView(
            bathymetryColors: Binding<BathymetryColors>(
                get: { .defaultColors },
                set: { _ in }
            )
        )
    }
}
