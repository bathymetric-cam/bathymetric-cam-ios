import XCTest
@testable import Bathymetry

// MARK: - MapRegionTests+BathymetryTile
class MapRegionBathymetryTileTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
 
  func testMapRegionBathymetryTile_whenLhsEqualsToRhs_lhsShouldContainRhs() throws {
    let lhs = try MapRegion(swTile: BathymetryTile(zoom: 16, x: 57482, y: 25954), neTile: BathymetryTile(zoom: 16, x: 57483, y: 25953))
    let rhs = try MapRegion(swTile: BathymetryTile(zoom: 16, x: 57482, y: 25954), neTile: BathymetryTile(zoom: 16, x: 57483, y: 25953))
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testMapRegionBathymetryTile_whenLhsIsLargerThanRhs_lhsShouldContainRhs() throws {
    let lhs = try MapRegion(swTile: BathymetryTile(zoom: 16, x: 57482, y: 25954), neTile: BathymetryTile(zoom: 16, x: 57483, y: 25953))
    let rhs = try lhs.bathymetryRegion(times: 0.5)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testMapRegionBathymetryTile_whenZoomIsDifferent_lhsShouldNotContainRhs() throws {
    let lhs = try MapRegion(swTile: BathymetryTile(zoom: 16, x: 57482, y: 25954), neTile: BathymetryTile(zoom: 16, x: 57483, y: 25953))
    let rhs = try lhs.bathymetryRegion(times: 2.0)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertFalse(result)
  }

}
