import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - ARToggleTests
class ARToggleTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testARToggle_whenToggleIsOn_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARToggle(
        isOn: Binding<Bool>(
          get: { true },
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
  
  func testARToggle_whenToggleIsOff_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARToggle(
        isOn: Binding<Bool>(
          get: { false },
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
