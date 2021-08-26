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
  
  func testBathymetryTile_whenLhsEqualsToRhs_lhsShouldEqualToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16)
    let rhs = BathymetryTile(x: 57482, y: 25954, zoom: 16)
      
    let result = lhs == rhs
      
    XCTAssertTrue(result)
  }
  
  func testBathymetryTile_whenCoordinateIsDifferent_lhsShouldNotEqualToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16)
    let rhs = BathymetryTile(x: 57483, y: 25954, zoom: 16)
      
    let result = lhs == rhs
      
    XCTAssertFalse(result)
  }
  
  func testBathymetryTile_whenZoomIsDifferent_lhsShouldNotEqualToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16)
    let rhs = BathymetryTile(x: 57482, y: 25954, zoom: 15)
      
    let result = lhs == rhs
      
    XCTAssertFalse(result)
  }
  
  func testBathymetryTile_whenRhsIsGeneratedFromLhsLocation_lhsShouldEqualToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16)
    let rhs = BathymetryTile(
      coordinate: CLLocationCoordinate2D(
        latitude: (lhs.ne.latitude + lhs.sw.latitude) / 2.0,
        longitude: (lhs.ne.longitude + lhs.sw.longitude) / 2.0
      ),
      zoom: lhs.zoom
    )
      
    XCTAssertEqual(lhs, rhs)
  }
}
