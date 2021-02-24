import XCTest
@testable import Bathymetry

// MARK: - BathymetryZoomLevelTests
class BathymetryZoomLevelTests: XCTestCase {
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryZoomLevel_whenMax_zoomOut() throws {
    var sut = BathymetryZoomLevel(.max)
    let expectations = [true, true, true, true, false]
    expectations.forEach {
      XCTAssertEqual(sut > .min, $0)
      sut.zoomOut()
    }
  }
  
  func testBathymetryZoomLevel_whenMin_zoomIn() throws {
    var sut = BathymetryZoomLevel(.min)
    let expectations = [true, true, true, true, false]
    expectations.forEach {
      XCTAssertEqual(sut < .max, $0)
      sut.zoomIn()
    }
  }
}
