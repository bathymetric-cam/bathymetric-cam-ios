import SwiftUI
import SnapshotTesting
import XCTest
@testable import Bathymetry

// MARK: - MapZoomButtonTests
class MapZoomButtonTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  func testMapZoomButton_whenTypeIsZoomIn_snapshotTesting() throws {
    assertSnapshot(
      matching: MapZoomButton(
        type: .zoomIn,
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { .max },
          set: { _ in }
        )
      ) { },
      as: .image(on: .iPhoneX)
    )
  }
 
}
