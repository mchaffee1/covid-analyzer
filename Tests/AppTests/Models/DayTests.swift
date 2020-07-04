import Foundation
import XCTest

@testable import App

class DayTests: XCTestCase {
    let mockLocation = MockLocation(fips: "fips", name: "name")
    let mockDate = IsoDate(year: 2020, month: 7, day: 4)

    func testShouldAddNewValues() {
        let newValues: Values = [.cases: 1, .deaths: 2]

        let day = Day(location: mockLocation, date: mockDate)
            .setting(newValues)

        XCTAssertEqual(day.values, newValues)
    }

    func testShouldReplaceValuesWithNew() {
        let newValues: Values = [.deaths: 3, .newCases: 4]
        let expectedValues: Values = [.cases: 1, .deaths: 3, .newCases: 4]

        let day = Day(location: mockLocation, date: mockDate, values: [.cases: 1, .deaths: 2])
            .setting(newValues)

        XCTAssertEqual(day.values, expectedValues)
    }

    func testShouldRemoveValuesForNil() {
        let day = Day(location: mockLocation,
                      date: mockDate,
                      values: [.cases: 1, .deaths: 2, .newCases: 3])
            .removing(.cases, .deaths)

        XCTAssertEqual(day.values, [.newCases: 3])
    }
}
