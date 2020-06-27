import Foundation
import XCTest

@testable import App

class DateComponents_IsoDayTests: XCTestCase {
    func testShouldReturnGoodComponentsFromGoodString() {
        let expected = DateComponents(year: 2020, month: 4, day: 24)

        XCTAssertEqual(DateComponents(isoDay: "2020-04-24"), expected)
    }

    func testShouldReturnNilForBadString() {
        XCTAssertNil(DateComponents(isoDay: "fasjkhfkasdjhf"))
    }
}
