import SwiftUI

// MARK: - BathymetryColor
struct BathymetryColor {
    let color: Color
    let depth: BathymetryDepth
    var uiColor: UIColor {
        UIColor(color)
    }
}

// MARK: - BathymetryColor + Equatable
extension BathymetryColor: Equatable {
    static func == (lhs: BathymetryColor, rhs: BathymetryColor) -> Bool {
        lhs.color == rhs.color && lhs.depth == rhs.depth
    }
}

// MARK: - BathymetryColor + Hashable
extension BathymetryColor: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(depth.min)
        hasher.combine(depth.max)
    }
}

// MARK: - BathymetryDepth
struct BathymetryDepth {
    let min: Double
    let max: Double
}

// MARK: - BathymetryDepth + Equatable
extension BathymetryDepth: Equatable {
    static func == (lhs: BathymetryDepth, rhs: BathymetryDepth) -> Bool {
        lhs.min == rhs.min && lhs.max == rhs.max
    }
}

// MARK: - BathymetryColors
typealias BathymetryColors = [BathymetryColor]

// MARK: - BathymetryColors + static constant
extension BathymetryColors {
    static let defaultColors = [
        BathymetryColor(color: .init(red: 0.878, green: 0.945, blue: 0.976), depth: BathymetryDepth(min: 0, max: 0.5)),
        BathymetryColor(color: .init(red: 0.718, green: 0.827, blue: 0.898), depth: BathymetryDepth(min: 0.5, max: 1.0)),
        BathymetryColor(color: .init(red: 0.435, green: 0.670, blue: 0.772), depth: BathymetryDepth(min: 1.0, max: 1.5)),
        BathymetryColor(color: .init(red: 0.149, green: 0.494, blue: 0.612), depth: BathymetryDepth(min: 1.5, max: 2.0)),
        BathymetryColor(color: .init(red: 0.0, green: 0.275, blue: 0.384), depth: BathymetryDepth(min: 2.0, max: 2.5)),
        BathymetryColor(color: .init(red: 0.012, green: 0.50, blue: 0.298), depth: BathymetryDepth(min: 2.5, max: 100000.0)),
    ]
}
