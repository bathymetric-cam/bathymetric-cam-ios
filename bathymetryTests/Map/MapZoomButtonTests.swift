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
