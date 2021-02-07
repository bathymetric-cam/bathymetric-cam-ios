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
    
    func testBathymetryRegion_whenLhsEqualsToRhs_lhsEqualsToRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        
        let result = lhs == rhs
        
        XCTAssertTrue(result)
    }
    
    func testBathymetryRegion_whenRegionTileIsDifferent_lhsNotEqualsToRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
        
        let result = lhs == rhs
        
        XCTAssertFalse(result)
    }
    
    func testBathymetryRegion_whenZoomIsDifferent_lhsNotEqualsToRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 15)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 16)
        
        let result = lhs == rhs
        
        XCTAssertFalse(result)
    }
    
    func testBathymetryRegion_whenLhsEqualsToRhs_lhsContainsRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        
        let result = lhs.contains(region: rhs)
        
        XCTAssertTrue(result)
    }
    
    func testBathymetryRegion_whenLhsIsLargerThanRhs_lhsContainsRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
        
        let result = lhs.contains(region: rhs)
        
        XCTAssertTrue(result)
    }
    
    func testBathymetryRegion_whenLhsIsSmallerThanLargerLhs_largerLhsContainsLhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        
        let result = lhs.largerRegion().contains(region: lhs)
        let result2 = lhs.contains(region: lhs.largerRegion())
        
        XCTAssertTrue(result)
        XCTAssertFalse(result2)
    }
    
    func testBathymetryRegion_whenLhsIsSmallerThanRhs_lhsNotContainsRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 57483, y: 25954), neTile: RegionTile(x: 57483, y: 25954), zoom: 16)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 57482, y: 25954), neTile: RegionTile(x: 57483, y: 25953), zoom: 16)
        
        let result = lhs.contains(region: rhs)
        
        XCTAssertFalse(result)
    }
    
    func testBathymetryRegion_whenZoomIsDifferent_lhsNotContainsRhs() throws {
        let lhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 15)
        let rhs = BathymetryRegion(swTile: RegionTile(x: 28742, y: 12977), neTile: RegionTile(x: 28742, y: 12977), zoom: 16)
        
        let result = lhs.contains(region: rhs)
        
        XCTAssertFalse(result)
    }
}
