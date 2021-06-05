import SwiftUI

// MARK: - Bathymetry
struct Bathymetry {
  let color: Color
  let depth: BathymetryDepth
}

// MARK: - Bathymetry + Equatable
extension Bathymetry: Equatable {
  static func == (lhs: Bathymetry, rhs: Bathymetry) -> Bool {
    lhs.color == rhs.color && lhs.depth == rhs.depth
  }
}

// MARK: - Bathymetry + Hashable
extension Bathymetry: Hashable {
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

// MARK: - BathymetryDepthUnit
enum BathymetryDepthUnit {
  case meter
  case feet
  
  // MARK: property
  
  var unit: String {
    switch self {
    case .meter:
      return "Meter"
    case .feet:
      return "Feet"
    }
  }
  
  var abbr: String {
    switch self {
    case .meter:
      return "m"
    case .feet:
      return "ft"
    }
  }
}

// MARK: - Double + Depth Unit
extension Double {
  var meter: Double { self }
  var feet: Double { self * 3.28084 }
}

// MARK: - BathymetryDepth + Equatable
extension BathymetryDepth: Equatable {
  static func == (lhs: BathymetryDepth, rhs: BathymetryDepth) -> Bool {
    lhs.min == rhs.min && lhs.max == rhs.max
  }
}

// MARK: - BathymetryColors
typealias Bathymetries = [Bathymetry]

// MARK: - Bathymetries + static constant
extension Bathymetries {
  static let `default` = [
    Bathymetry(color: .init(red: 241.0 / 255, green: 250.0 / 255, blue: 253.0 / 255), depth: BathymetryDepth(min: 0.0, max: 1.0)),
    Bathymetry(color: .init(red: 224.0 / 255, green: 241.0 / 255, blue: 249.0 / 255), depth: BathymetryDepth(min: 1.0, max: 2.0)),
    Bathymetry(color: .init(red: 183.0 / 255, green: 211.0 / 255, blue: 229.0 / 255), depth: BathymetryDepth(min: 2.0, max: 3.0)),
    Bathymetry(color: .init(red: 111.0 / 255, green: 171.0 / 255, blue: 197.0 / 255), depth: BathymetryDepth(min: 3.0, max: 5.0)),
    Bathymetry(color: .init(red: 38.0 / 255, green: 126.0 / 255, blue: 156.0 / 255), depth: BathymetryDepth(min: 5.0, max: 10.0)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 70.0 / 255, blue: 98.0 / 255), depth: BathymetryDepth(min: 10.0, max: 20.0)),
    Bathymetry(color: .init(red: 3.0 / 255, green: 51.0 / 255, blue: 76.0 / 255), depth: BathymetryDepth(min: 20.0, max: 50.0)),
  ]
}
