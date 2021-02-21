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
  
  func testAppStore_whenInitialState_loadBathymetriesSuccess() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: .mock()
      )
    )
    sut.assert(
      .environment {
        $0.bathymetryClient.loadBathymetries = { _ in Effect(value: mockBathymetryTiles) }
      },
      .send(.loadBathymetries(mockRegion)) {
        $0.region = mockRegion.largerRegion()
      },
      .do { self.scheduler.advance(by: 0.1) },
      .receive(.bathymetriesResult(.success(mockBathymetryTiles))) {
        $0.bathymetryTiles = mockBathymetryTiles
      }
    )
  }
  
  func testAppStore_whenInitialState_loadBathymetriesFailure() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: .mock()
      )
    )
    sut.assert(
      .environment {
        $0.bathymetryClient.loadBathymetries = { _ in Effect(error: mockFailure) }
      },
      .send(.loadBathymetries(mockRegion)) {
        $0.region = mockRegion.largerRegion()
      },
      .do { self.scheduler.advance(by: 0.1) },
      .receive(.bathymetriesResult(.failure(mockFailure)))
    )
  }
  
  func testAppStore_whenInitialState_zoomIn() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: .mock()
      )
    )
    sut.assert(
      .send(.zoomIn) {
        $0.zoomLevel.zoomIn()
      }
    )
  }
  
  func testAppStore_whenInitialState_zoomOut() throws {
    let sut = TestStore(
    initialState: .init(bathymetryColors: .defaultColors),
      reducer: appReducer,
      environment: AppEnvironment(
      mainQueue: scheduler.eraseToAnyScheduler(),
      bathymetryClient: .mock()
      )
    )
    sut.assert(
      .send(.zoomOut) {
        $0.zoomLevel.zoomOut()
      }
    )
  }
  
  func testAppStore_whenInitialState_arIsOnChanged() throws {
    let sut = TestStore(
      initialState: .init(bathymetryColors: .defaultColors),
        reducer: appReducer,
        environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler(),
        bathymetryClient: .mock()
      )
    )
    sut.assert(
      .send(.arIsOnChanged(false)) {
        $0.arIsOn = false
      },
      .do { self.scheduler.advance(by: 0.1) },
      .send(.arIsOnChanged(true)) {
        $0.arIsOn = true
      }
    )
  }
}

// MARK: - mock
private let mockBathymetryTiles = [BathymetryTile(x: 57483, y: 25954, zoom: 16, features: [])]
private let mockRegion = BathymetryRegion(
  swTile: RegionTile(x: 57483, y: 25954),
  neTile: RegionTile(x: 57483, y: 25954),
  zoom: 16
)
private enum MockError: Error {
  case mock
}
private let mockFailure: BathymetryClient.Failure = .otherFailure(MockError.mock)

// MARK: - BathymetryClient+Mock
extension BathymetryClient {
  // MARK: property
  
  static func mock(
    loadBathymetries: @escaping (_ region: BathymetryRegion) -> Effect<[BathymetryTile], Failure> = { _ in
    fatalError("Unmocked")
  }) -> Self {
    Self(loadBathymetries: loadBathymetries)
  }
}
