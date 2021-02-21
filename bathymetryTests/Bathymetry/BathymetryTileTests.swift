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
  
  func testRegionTile_whenLhsEqualsToRhs_lhsEqualsToRhs() throws {
    let lhs = RegionTile(x: 57482, y: 25954)
    let rhs = RegionTile(x: 57482, y: 25954)
      
    XCTAssertEqual(lhs, rhs)
  }
  
  func testRegionTile_whenCoordinateIsDifferent_lhsNotEqualsToRhs() throws {
    let lhs = RegionTile(x: 57482, y: 25954)
    let rhs = RegionTile(x: 57483, y: 25954)
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testBathymetryTile_whenLhsEqualsToRhs_lhsEqualsToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16, features: [])
    let rhs = BathymetryTile(x: 57482, y: 25954, zoom: 16, features: [])
      
    let result = lhs == rhs
      
    XCTAssertTrue(result)
  }
  
  func testBathymetryTile_whenCoordinateIsDifferent_lhsNotEqualsToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16, features: [])
    let rhs = BathymetryTile(x: 57483, y: 25954, zoom: 16, features: [])
      
    let result = lhs == rhs
      
    XCTAssertTrue(result)
  }
  
  func testBathymetryTile_whenZoomIsDifferent_lhsNotEqualsToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16, features: [])
    let rhs = BathymetryTile(x: 57482, y: 25954, zoom: 15, features: [])
      
    let result = lhs == rhs
      
    XCTAssertFalse(result)
  }
  
  func testBathymetryTile_whenRhsIsGeneratedFromLhsLocation_lhsEqualsToRhs() throws {
    let lhs = BathymetryTile(x: 57482, y: 25954, zoom: 16, features: [])
    let rhs = BathymetryTile(
      coordinate: CLLocationCoordinate2D(
        latitude: (lhs.ne.latitude + lhs.sw.latitude) / 2.0,
        longitude: (lhs.ne.longitude + lhs.sw.longitude) / 2.0
      ),
      zoom: lhs.zoom,
      features: []
    )
      
    XCTAssertEqual(lhs, rhs)
  }
}
