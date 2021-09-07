import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - ARWaterSurfaceButtonTests
class ARWaterSurfaceButtonTests: XCTestCase {
  // MARK: static property
  
  static let top = -0.5
  static let bottom = -15.0
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testARWaterSurfaceButton_whenButtonTypeIsUpInAndWaterSurfaceIsTop_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceButton(
        type: .up,
        top: ARWaterSurfaceButtonTests.top,
        bottom: ARWaterSurfaceButtonTests.bottom,
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceButtonTests.top },
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
  
  func testARWaterSurfaceButton_whenButtonTypeIsDownInAndWaterSurfaceIsTop_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceButton(
        type: .down,
        top: ARWaterSurfaceButtonTests.top,
        bottom: ARWaterSurfaceButtonTests.bottom,
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceButtonTests.top },
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
  
  func testARWaterSurfaceButton_whenButtonTypeIsUpInAndWaterSurfaceIsBottom_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceButton(
        type: .up,
        top: ARWaterSurfaceButtonTests.top,
        bottom: ARWaterSurfaceButtonTests.bottom,
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceButtonTests.bottom },
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
  
  func testARWaterSurfaceButton_whenButtonTypeIsDownInAndWaterSurfaceIsBottom_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceButton(
        type: .down,
        top: ARWaterSurfaceButtonTests.top,
        bottom: ARWaterSurfaceButtonTests.bottom,
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceButtonTests.bottom },
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
