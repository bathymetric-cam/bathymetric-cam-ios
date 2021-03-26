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
  
  func testBathymetryZoomLevel_whenMax_shouldBeAbleToZoomOut() throws {
    var sut = BathymetryZoomLevel(.max)
    let times = Int(round((BathymetryZoomLevel(.max) - BathymetryZoomLevel(.min)) / BathymetryZoomLevel(.unit)))
    for _ in (0...(times - 1)) {
      XCTAssertNotEqual(sut, .min, accuracy: 0.0001)
      sut.zoomOut()
    }
    XCTAssertEqual(sut, .min, accuracy: 0.0001)
    sut.zoomOut()
    XCTAssertEqual(sut, .min, accuracy: 0.0001)
  }
  
  func testBathymetryZoomLevel_whenMin_shouldBeAbleToZoomIn() throws {
    var sut = BathymetryZoomLevel(.min)
    let times = Int(round((BathymetryZoomLevel(.max) - BathymetryZoomLevel(.min)) / BathymetryZoomLevel(.unit)))
    for _ in (0...(times - 1)) {
      XCTAssertNotEqual(sut, .max, accuracy: 0.0001)
      sut.zoomIn()
    }
    XCTAssertEqual(sut, .max, accuracy: 0.0001)
    sut.zoomIn()
    XCTAssertEqual(sut, .max, accuracy: 0.0001)
  }
}
