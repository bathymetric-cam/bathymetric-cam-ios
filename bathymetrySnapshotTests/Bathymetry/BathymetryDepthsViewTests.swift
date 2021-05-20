import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - BathymetryDepthsViewTests
class BathymetryDepthsViewTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryDepthsView_whenInitialState_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryDepthsView(
        bathymetries: Binding<[Bathymetry]>(
          get: { .default },
          set: { _ in }
        ),
        width: Binding<CGFloat>(
          get: { 4 },
          set: { _ in }
        ),
        height: Binding<CGFloat>(
          get: { BathymetrySlider.colorsViewPlusSliderHeight },
          set: { _ in }
        )
      )
    )
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
