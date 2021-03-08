import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - BathymetryColorsViewTests
class BathymetryColorsViewTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryColorsView_whenInitialState_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryColorsView(
        bathymetryColors: Binding<BathymetryColors>(
          get: { .defaultColors },
          set: { _ in }
        )
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .image(on: .iPhoneX, precision: 0.9),
        named: named
      )
    }
  }
}
