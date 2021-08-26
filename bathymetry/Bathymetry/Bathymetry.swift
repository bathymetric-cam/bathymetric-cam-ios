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
    Bathymetry(color: .init(red: 240.0 / 255, green: 250.0 / 255, blue: 255.0 / 255), depth: .init(min: 0.0, max: 0.5)),
    Bathymetry(color: .init(red: 210.0 / 255, green: 225.0 / 255, blue: 240.0 / 255), depth: .init(min: 0.5, max: 1.0)),
    Bathymetry(color: .init(red: 180.0 / 255, green: 200.0 / 255, blue: 225.0 / 255), depth: .init(min: 1.0, max: 1.5)),
    Bathymetry(color: .init(red: 150.0 / 255, green: 175.0 / 255, blue: 210.0 / 255), depth: .init(min: 1.5, max: 2.0)),
    Bathymetry(color: .init(red: 120.0 / 255, green: 150.0 / 255, blue: 195.0 / 255), depth: .init(min: 2.0, max: 2.5)),
    Bathymetry(color: .init(red: 90.0 / 255, green: 125.0 / 255, blue: 180.0 / 255), depth: .init(min: 2.5, max: 3.0)),
    Bathymetry(color: .init(red: 60.0 / 255, green: 100.0 / 255, blue: 165.0 / 255), depth: .init(min: 3.0, max: 3.5)),
    Bathymetry(color: .init(red: 30.0 / 255, green: 75.0 / 255, blue: 150.0 / 255), depth: .init(min: 3.5, max: 4.0)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 50.0 / 255, blue: 135.0 / 255), depth: .init(min: 4.0, max: 4.5)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 25.0 / 255, blue: 120.0 / 255), depth: .init(min: 4.5, max: 5.0)),
    /*
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 105.0 / 255), depth: .init(min: 5.0, max: 5.5)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 90.0 / 255), depth: .init(min: 5.5, max: 6.0)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 75.0 / 255), depth: .init(min: 6.0, max: 6.5)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 60.0 / 255), depth: .init(min: 6.5, max: 7.0)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 45.0 / 255), depth: .init(min: 7.0, max: 7.5)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 30.0 / 255), depth: .init(min: 7.5, max: 8.0)),
    Bathymetry(color: .init(red: 0.0 / 255, green: 0.0 / 255, blue: 15.0 / 255), depth: .init(min: 8.0, max: 8.5)),
    */
  ]
}
