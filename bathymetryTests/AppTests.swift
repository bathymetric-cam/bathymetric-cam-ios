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
    
    func testAppStore_whenInitialState_loadBathymetries() throws {
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
                $0.bathymetryClient.loadBathymetries = { _ in Effect(value: mockBathymetries) }
            },
            .send(.loadBathymetries(mockRegion)),
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.bathymetriesResult(.success(mockBathymetries))) { _ in
            }
        )
    }

}

// MARK: - mock
private let mockBathymetries = [Bathymetry(x: 57483, y: 25954, zoom: 16)]
private let mockRegion = Region(
    swTile: RegionTile(x: 57483, y: 25954, zoom: 16),
    neTile: RegionTile(x: 57483, y: 25954, zoom: 16)
)
