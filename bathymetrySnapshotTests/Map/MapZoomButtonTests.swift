import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - MapZoomButtonTests
class MapZoomButtonTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testMapZoomButton_whenTypeIsZoomInAndZoomLevelIsMax_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomButton(
        type: .zoomIn,
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { .max },
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
  
  func testMapZoomButton_whenTypeIsZoomInAndZoomLevelIsMin_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomButton(
        type: .zoomIn,
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { .min },
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
  
  func testMapZoomButton_whenTypeIsZoomOutAndZoomLevelIsMax_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomButton(
        type: .zoomOut,
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { .max },
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
  
  func testMapZoomButton_whenTypeIsZoomOutAndZoomLevelIsMin_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomButton(
        type: .zoomOut,
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { .min },
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
