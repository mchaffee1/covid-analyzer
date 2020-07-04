import Foundation
import XCTest

@testable import App

class CensusStateTests: XCTestCase {
    func testShouldDecodeFromDict() {
        let dict: [String: String] = [
            "POP": "2976149",
            "NAME": "Mississippi",
            "state": "28"
        ]
        let json = try! JSONEncoder().encode(dict)

        do {
            let censusState = try JSONDecoder().decode(CensusState.self, from: json)
            XCTAssertEqual(censusState, CensusState(fips: "28", name: "Mississippi", pop: "2976149"))
        } catch {
            XCTFail("decode from json failed with error: \(error)")
            return
        }
    }

    func testShouldComputeProperties() {
        let censusState = CensusState(fips: "28", name: "Mississippi", pop: "2976149")

        XCTAssertEqual(censusState.population, 2976149)
    }
}
