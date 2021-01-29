import SwiftUI

// MARK: - BathymetryColor
struct BathymetryColor {
    let color: Color
    let depth: BathymetryDepth
}

// MARK: - BathymetryDepth
struct BathymetryDepth {
    let min: Double
    let max: Double
}

// MARK: - BathymetryColors
typealias BathymetryColors = [BathymetryColor]
extension BathymetryColors {
    static let defaultColors = [
        BathymetryColor(color: .init(red: 0, green: 0, blue: 0.5), depth: BathymetryDepth(min: 0, max: 0.5)),
        BathymetryColor(color: .init(red: 0, green: 0, blue: 0.75), depth: BathymetryDepth(min: 0.5, max: 1.0)),
        BathymetryColor(color: .init(red: 0, green: 0, blue: 1.0), depth: BathymetryDepth(min: 1.5, max: .infinity)),
    ]
}
