import Foundation
@testable import Bathymetry

// MARK: - MapTileFake
struct MapTileFake: MapTile, Equatable {
  // MARK: property
  let zoom: Int
  let x: Int
  let y: Int
  
  // MARK: Equatable
  static func == (lhs: MapTileFake, rhs: MapTileFake) -> Bool {
    lhs.zoom == rhs.zoom && lhs.x == rhs.x && lhs.y == rhs.y
  }
}
