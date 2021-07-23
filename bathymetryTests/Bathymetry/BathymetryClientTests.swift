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
  
  func testBathymetryClient_whenInitialState_loadBathymetriesShouldSucceed() throws {
    var result: [BathymetryTile]? = nil
    let exp = expectation(description: #function)
    let sut = BathymetryClientSuccessFake()
  
    _ = sut.loadBathymetries(testRegion)
      .sink(
        receiveCompletion: { _ in exp.fulfill() },
        receiveValue: { result = $0 }
      )
  
    wait(for: [exp], timeout: 0.1)
    XCTAssertTrue(result == testBathymetryTiles)
  }
  
  func testBathymetryClient_whenInitialState_loadBathymetriesShouldFail() throws {
    var result: BathymetryClientFailure? = nil
    let exp = expectation(description: #function)
    let sut = BathymetryClientFailureFake()
      
    _ = sut.loadBathymetries(testRegion)
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
    XCTAssertTrue(result == testFailure)
  }
}
