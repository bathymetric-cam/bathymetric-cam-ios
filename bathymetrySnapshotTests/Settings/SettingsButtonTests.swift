import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - SettingsButtonTests
class SettingsButtonTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testSettingsButton_whenInitialState_snapshotTesting() throws {
    let sut = UIHostingController(rootView: SettingsButton {})
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
}
