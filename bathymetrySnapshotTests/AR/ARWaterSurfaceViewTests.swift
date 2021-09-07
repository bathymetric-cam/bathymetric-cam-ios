import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - ARWaterSurfaceViewTests
class ARWaterSurfaceViewTests: XCTestCase {
  // MARK: static constant
  
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
  
  func testARWaterSurfaceView_whenDepthUnitIsMeter_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { (ARWaterSurfaceViewTests.top + ARWaterSurfaceViewTests.bottom) / 2 },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .meter },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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
  
  func testARWaterSurfaceView_DepthUnitIsFeet_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { (ARWaterSurfaceViewTests.top + ARWaterSurfaceViewTests.bottom) / 2 },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .feet },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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
 
  func testARWaterSurfaceView_whenWaterSurfaceIsTopAndDepthUnitIsMeter_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceViewTests.top },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .meter },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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
  
  func testARWaterSurfaceView_whenWaterSurfaceIsTopAndDepthUnitIsFeet_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceViewTests.top },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .feet },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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

  func testARWaterSurfaceView_whenWaterSurfaceIsBottomAndDepthUnitIsMeter_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceViewTests.bottom },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .meter },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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
  
  func testARWaterSurfaceView_whenWaterSurfaceIsBottomAndDepthUnitIsFeet_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: ARWaterSurfaceView(
        waterSurface: Binding<Double>(
          get: { ARWaterSurfaceViewTests.bottom },
          set: { _ in }
        ),
        depthUnit: Binding<BathymetryDepthUnit>(
          get: { .feet },
          set: { _ in }
        ),
        top: ARWaterSurfaceViewTests.top,
        bottom: ARWaterSurfaceViewTests.bottom
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
