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
  
  func testAppStore_whenInitialState_() throws {
    /*
    let sut = TestStore(
      initialState: .init(bathymetries: .default),
      reducer: appReducer,
      environment: AppEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler()
      )
    )
    sut.assert(
      .send(.loadBathymetries(testRegion)) {
        $0.region = testRegion.largerRegion()
      },
      .do { self.scheduler.advance(by: 0.1) },
      .receive(.bathymetriesResult(.success(testBathymetryTiles))) {
        $0.bathymetryTiles = testBathymetryTiles
      }
    )
    */
  }
}
