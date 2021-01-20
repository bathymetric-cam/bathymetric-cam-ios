import ComposableArchitecture
import GEOSwift
import XCTest
@testable import Bathymetry

// MARK: - AppTests
class AppTests: XCTestCase {

    // MARK: - property
    
    let scheduler = DispatchQueue.testScheduler
    
    // MARK: - life cycle
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    // MARK: - test
    
    func testAppStore_whenInitialState_loadBathymetriesSuccess() throws {
        let sut = TestStore(
          initialState: .init(),
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
            .send(.loadBathymetries(mockRegion)),
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.bathymetriesResult(.success(mockBathymetryTiles)))
        )
    }
    
    func testAppStore_whenInitialState_loadBathymetriesFailure() throws {
        let sut = TestStore(
          initialState: .init(),
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
            .send(.loadBathymetries(mockRegion)),
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.bathymetriesResult(.failure(mockFailure)))
        )
    }
}

// MARK: - mock
private let mockBathymetryTiles = [BathymetryTile(x: 57483, y: 25954, zoom: 16, features: [])]
private let mockRegion = Region(
    swTile: RegionTile(x: 57483, y: 25954, zoom: 16),
    neTile: RegionTile(x: 57483, y: 25954, zoom: 16)
)
private let mockFailure = BathymetryClient.Failure()
