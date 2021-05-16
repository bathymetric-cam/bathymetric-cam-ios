import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - BathymetryWaterSurfaceSliderTests
class BathymetryWaterSurfaceSliderTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testBathymetryWaterSurfaceSlider_whenWaterSurfaceEqualsToMinusZeroPointFive_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryWaterSurfaceSlider(
        waterSurface: Binding<Double>(
          get: { -0.5 },
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
  
  func testBathymetryWaterSurfaceSlider_whenWaterSurfaceEqualsToMinusFifteen_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryWaterSurfaceSlider(
        waterSurface: Binding<Double>(
          get: { -15 },
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
  
  func testBathymetryWaterSurfaceSlider_whenWaterSurfaceEqualsToMinusSevenPointFive_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: BathymetryWaterSurfaceSlider(
        waterSurface: Binding<Double>(
          get: { -7.5 },
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
