import Combine
import ComposableArchitecture
import GEOSwift
import XCTest
@testable import Bathymetry

// MARK: - BathymetryClientTests
class BathymetryClientTests: XCTestCase {
    
    // MARK: life cycle
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    // MARK: test
    
    func testBathymetryClient_whenInitialState_loadBathymetriesSuccess() throws {
        var result: [BathymetryTile]? = nil
        let exp = expectation(description: #function)
        let sut = BathymetryClient.fakeSuccessClient
        
        _ = sut.loadBathymetries(mockRegion)
            .sink(
                receiveCompletion: { _ in exp.fulfill() },
                receiveValue: { result = $0 }
            )
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertTrue(result == mockBathymetryTiles)
    }
    
    func testBathymetryClient_whenInitialState_loadBathymetriesFailure() throws {
        var result: BathymetryClient.Failure? = nil
        let exp = expectation(description: #function)
        let sut = BathymetryClient.fakeFailureClient
        
        _ = sut.loadBathymetries(mockRegion)
            .sink(
                receiveCompletion: {
                    if case let .failure(failure) = $0 {
                        result = failure
                    }
                    exp.fulfill()
                },
                receiveValue: { _ in }
            )
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertTrue(result == mockFailure)
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

// MARK: - BathymetryClient+Fake
extension BathymetryClient {
    // MARK: property
    
    static let fakeSuccessClient = BathymetryClient { region in
        Future<[BathymetryTile], Failure> { promise in
            promise(.success(mockBathymetryTiles))
        }
        .eraseToEffect()
    }
    
    static let fakeFailureClient = BathymetryClient { region in
        Future<[BathymetryTile], Failure> { promise in
            promise(.failure(mockFailure))
        }
        .eraseToEffect()
    }
}
