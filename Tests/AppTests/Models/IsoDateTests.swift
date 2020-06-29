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

    func testShouldReturnCorrectDifferenceForDifferentYear() {
        XCTAssertTrue(IsoDate(isoString: "1992-04-24")! < IsoDate(isoString: "2020-04-24")!)
    }

    func testShouldReturnCorrectDifferenceForDifferentMonth() {
        XCTAssertFalse(IsoDate(isoString: "1992-04-24")! < IsoDate(isoString: "1992-03-24")!)
    }

    func testShouldReturnCorrectDifferenceForDifferentDay() {
        XCTAssertTrue(IsoDate(isoString: "1992-04-24")! < IsoDate(isoString: "1992-04-25")!)
    }

    func testShouldReturnCorrectDifferenceForSameDate() {
        XCTAssertFalse(IsoDate(isoString: "1992-04-24")! < IsoDate(isoString: "1992-04-24")!)
    }
}
