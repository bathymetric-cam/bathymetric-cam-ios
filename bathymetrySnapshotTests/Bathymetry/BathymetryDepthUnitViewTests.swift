import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - BathymetryDepthUnitViewTests
class BathymetryDepthUnitViewTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryDepthUnitView_whenDepthUnitIsMeter_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryDepthUnitView(
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .meter },
          set: { _ in }
        )
      )
    )
    [(UIUserInterfaceStyle.dark, "dark"), (UIUserInterfaceStyle.light, "light")].forEach { style, named in
      sut.overrideUserInterfaceStyle = style
      assertSnapshot(
        matching: sut,
        as: .img(precision: 0.98),
        named: named + "." + model.name
      )
    }
  }
  
  func testBathymetryDepthUnitView_whenDepthUnitIsFeet_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryDepthUnitView(
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .feet },
          set: { _ in }
        )
      )
    )
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
