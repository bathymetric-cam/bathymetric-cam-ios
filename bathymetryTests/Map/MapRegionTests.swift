import XCTest
@testable import Bathymetry

// MARK: - MapRegionTests
class MapRegionTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testMapRegion_whenLhsEqualsToRhs_lhsShouldBeEqualToRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
  
    XCTAssertEqual(lhs, rhs)
  }
  
  func testMapRegion_whenCoordinateIsDifferent_lhsShouldNotBeEqualToRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57483, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25954))
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testMapRegion_whenZoomIsDifferent_lhsShouldNotBeEqualToRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 15, x: 28742, y: 12977), neTile: MapTileFake(zoom: 15, x: 28742, y: 12977))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 28742, y: 12977), neTile: MapTileFake(zoom: 16, x: 28742, y: 12977))
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testMapRegion_whenLhsEqualsToRhs_lhsShouldContainRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testMapRegion_whenLhsIsLargerThanRhs_lhsShouldContainRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57482, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25953))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 57483, y: 25954), neTile: MapTileFake(zoom: 16, x: 57483, y: 25954))
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testMapRegion_whenZoomIsDifferent_lhsShouldNotContainRhs() throws {
    let lhs = try MapRegion(swTile: MapTileFake(zoom: 15, x: 28742, y: 12977), neTile: MapTileFake(zoom: 15, x: 28742, y: 12977))
    let rhs = try MapRegion(swTile: MapTileFake(zoom: 16, x: 28742, y: 12977), neTile: MapTileFake(zoom: 16, x: 28742, y: 12977))
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertFalse(result)
  }
}
