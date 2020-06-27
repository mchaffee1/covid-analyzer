import Foundation
import XCTest

@testable import App

class IsoDateTests: XCTestCase {
    func testShouldReturnGoodComponentsFromGoodString() {
        let expected = IsoDate(year: 2020, month: 4, day: 24)

        XCTAssertEqual(IsoDate(isoString: "2020-04-24"), expected)
    }

    func testShouldReturnNilForBadString() {
        XCTAssertNil(IsoDate(isoString: "fasjkhfkasdjhf"))
    }

    func testShouldReturnIsoDayString() {
        let isoDate = IsoDate(year: 2020, month: 4, day: 24)

        XCTAssertEqual(isoDate.description, "2020-04-24")
    }
}
