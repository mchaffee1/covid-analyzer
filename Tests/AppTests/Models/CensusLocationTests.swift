import Foundation
import XCTest

@testable import App

class CensusLocationTests: XCTestCase {
    func testShouldDecodeStateFromDict() {
        let dict: [String: String] = [
            "POP": "2976149",
            "NAME": "Mississippi",
            "state": "28"
        ]
        let json = try! JSONEncoder().encode(dict)

        do {
            let censusLocation = try JSONDecoder().decode(CensusLocation.self, from: json)
            XCTAssertEqual(censusLocation, CensusLocation(fips: "28", name: "Mississippi", pop: "2976149"))
        } catch {
            XCTFail("decode from json failed with error: \(error)")
            return
        }
    }

    func testShouldComputeProperties() {
        let censusLocation = CensusLocation(fips: "28", name: "Mississippi", pop: "2976149")

        XCTAssertEqual(censusLocation.population, 2976149)
    }
}
