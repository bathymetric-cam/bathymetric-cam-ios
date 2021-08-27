import XCTest
@testable import Bathymetry

// MARK: - MapTileTests
class MapTileTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testMapTileFake_whenLhsEqualsToRhs_lhsShouldBeEqualToRhs() throws {
    let lhs = MapTileFake(zoom: 16, x: 57482, y: 25954)
    let rhs = MapTileFake(zoom: 16, x: 57482, y: 25954)
      
    XCTAssertEqual(lhs, rhs)
  }
  
  func testMapTileFake_whenCoordinateIsDifferent_lhsShouldNotBeEqualToRhs() throws {
    let lhs = MapTileFake(zoom: 16, x: 57482, y: 25954)
    let rhs = MapTileFake(zoom: 16, x: 57483, y: 25954)
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testMapTileFake_whenZoomIsDifferent_lhsShouldNotBeEqualToRhs() throws {
    let lhs = MapTileFake(zoom: 16, x: 57482, y: 25954)
    let rhs = MapTileFake(zoom: 15, x: 57482, y: 25954)
    
    XCTAssertNotEqual(lhs, rhs)
  }
}
