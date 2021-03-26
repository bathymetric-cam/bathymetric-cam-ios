import XCTest
@testable import Bathymetry

// MARK: - BathymetryRegionTests
class BathymetryRegionTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryRegion_whenLhsEqualsToRhs_lhsShouldEqualToRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
  
    XCTAssertEqual(lhs, rhs)
  }
  
  func testBathymetryRegion_whenCoordinateIsDifferent_lhsShouldNotEqualToRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testBathymetryRegion_whenZoomIsDifferent_lhsShouldNotEqualToRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 15)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 16)
      
    XCTAssertNotEqual(lhs, rhs)
  }
  
  func testBathymetryRegion_whenLhsEqualsToRhs_lhsShouldContainRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testBathymetryRegion_whenLhsIsLargerThanRhs_lhsShouldContainRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertTrue(result)
  }
  
  func testBathymetryRegion_whenLhsIsSmallerThanLargerLhs_largerLhsShouldContainLhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
      
    let result = lhs.largerRegion().contains(region: lhs)
    let result2 = lhs.contains(region: lhs.largerRegion())
      
    XCTAssertTrue(result)
    XCTAssertFalse(result2)
  }
  
  func testBathymetryRegion_whenLhsIsSmallerThanRhs_lhsShouldNotContainRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertFalse(result)
  }
  
  func testBathymetryRegion_whenZoomIsDifferent_lhsShouldNotContainRhs() throws {
    let lhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 15)
    let rhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 16)
      
    let result = lhs.contains(region: rhs)
      
    XCTAssertFalse(result)
  }
}
