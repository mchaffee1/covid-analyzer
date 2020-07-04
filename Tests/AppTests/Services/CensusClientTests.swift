import Foundation
import XCTest

@testable import App

class CensusClientTests: XCTestCase {
    func testShouldDigestMatrix() {
        let matrix: [[String]] = [
            ["first", "second"],
            ["1", "2"],
            ["3", "4"]
        ]
        let expectedArray: [[String: String]] = [
            ["first": "1", "second": "2"],
            ["first": "3", "second": "4"]
        ]

        XCTAssertEqual(CensusClient().dictArray(from: matrix), expectedArray)
    }

    func testShouldWork() {
        let censusClient = CensusClient()

        let expectation = XCTestExpectation(description: "fetching census states")
        censusClient.getRawStates { censusStates in
            let newYork = censusStates["36"]
            XCTAssertEqual(newYork?.name , "New York")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
