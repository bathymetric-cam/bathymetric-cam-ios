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
    sut.overrideUserInterfaceStyle = .dark
    assertSnapshot(
      matching: sut,
      as: .image,
      named: "dark"
    )
    sut.overrideUserInterfaceStyle = .light
    assertSnapshot(
      matching: sut,
      as: .image,
      named: "light"
    )
  }
}
