import Combine
import ComposableArchitecture
import GEOSwift
import XCTest
@testable import Bathymetry

// MARK: - AppTests
class AppTests: XCTestCase {

  // MARK: property
  
  let scheduler = DispatchQueue.testScheduler
  
  // MARK: life cycle
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  // MARK: test
  
  func testAppStore_whenInitialState_loadBathymetriesShouldSucceed() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        bathymetryClient: BathymetryClientSuccessMock()
      )
    )
    sut.assert(
      .send(.loadBathymetries(mockRegion)) {
        $0.region = mockRegion.largerRegion()
      },
      .do { self.scheduler.advance(by: 0.1) },
      .receive(.bathymetriesResult(.success(mockBathymetryTiles))) {
        $0.bathymetryTiles = mockBathymetryTiles
      }
    )
  }
  
  func testAppStore_whenInitialState_loadBathymetriesShouldFail() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        bathymetryClient: BathymetryClientFailureMock()
      )
    )
    sut.assert(
      .send(.loadBathymetries(mockRegion)) {
        $0.region = mockRegion.largerRegion()
      },
      .do { self.scheduler.advance(by: 0.1) },
      .receive(.bathymetriesResult(.failure(mockFailure)))
    )
  }
  
  func testAppStore_whenInitialState_shouldBeAbleToZoomIn() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: BathymetryClientSuccessMock()
      )
    )
    sut.assert(
      .send(.zoomIn) {
        $0.zoomLevel.zoomIn()
      }
    )
  }
  
  func testAppStore_whenInitialState_shouldBeAbleToZoomOut() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: BathymetryClientSuccessMock()
      )
    )
    sut.assert(
      .send(.zoomOut) {
        $0.zoomLevel.zoomOut()
      }
    )
  }
  
  func testAppStore_whenInitialState_arIsOnToggledShouldWork() throws {
    let sut = TestStore(
      initialState: .init(bathymetryColors: .defaultColors),
        reducer: appReducer,
        environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        bathymetryClient: BathymetryClientSuccessMock()
      )
    )
    sut.assert(
      .send(.arIsOnToggled(false)) {
        $0.arIsOn = false
      },
      .do { self.scheduler.advance(by: 0.1) },
      .send(.arIsOnToggled(true)) {
        $0.arIsOn = true
      }
    )
  }
}
