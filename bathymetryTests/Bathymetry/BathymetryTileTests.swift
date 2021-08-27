import CoreLocation
import XCTest
@testable import Bathymetry

// MARK: - BathymetryTileTests
class BathymetryTileTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryTile_whenRhsIsGeneratedFromLhsLocation_lhsShouldBeEqualToRhs() throws {
    let lhs = BathymetryTile(zoom: 16, x: 57482, y: 25954)
    let rhs = BathymetryTile(
      zoom: lhs.zoom,
      coordinate: CLLocationCoordinate2D(
        latitude: (lhs.ne.latitude + lhs.sw.latitude) / 2.0,
        longitude: (lhs.ne.longitude + lhs.sw.longitude) / 2.0
      )
    )
      
    XCTAssertEqual(lhs, rhs)
  }
}
