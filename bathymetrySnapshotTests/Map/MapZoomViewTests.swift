import SnapshotTesting
import SwiftUI
import XCTest
@testable import Bathymetry

// MARK: - MapZoomViewTests
class MapZoomViewTests: XCTestCase {
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testMapZoomView_whenZoomLevelIsMax_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomView(
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
  
  func testMapZoomView_whenZoomLevelIsMin_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomView(
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
  
  func testMapZoomView_whenZoomLevelIsMidOfMaxAndMin_snapshotTesting() throws {
    let sut = UIHostingController(
      rootView: MapZoomView(
        zoomLevel: Binding<BathymetryZoomLevel>(
          get: { (.min + .max) / 2 },
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
