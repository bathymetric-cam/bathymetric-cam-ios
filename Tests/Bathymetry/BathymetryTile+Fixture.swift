import UIKit
@testable import Bathymetry

// MARK: - BathymetryTile + Fixture
extension BathymetryTile {
  // MARK: static api
  
  static func fixture() -> BathymetryTile {
    BathymetryTile(zoom: 16, x: 57508, y: 25958, image: UIImage(named: "16.57508.25958"))
  }
  
  static func fixture(zoom: Int, x: Int, y: Int) -> BathymetryTile {
    BathymetryTile(zoom: 16, x: 57508, y: 25958, image: UIImage(named: "\(zoom).\(x).\(y)"))
  }
}
