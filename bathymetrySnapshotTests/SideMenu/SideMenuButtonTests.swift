import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - SideMenuButtonTests
class SideMenuButtonTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testSideMenuButton_whenInitialState_snapshotTesting() throws {
    let sut = UIHostingController(rootView: SideMenuButton {})
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhone8, precision: 0.98, traits: .iPhone8(.portrait)),
        named: named
      )
    }
  }
}
