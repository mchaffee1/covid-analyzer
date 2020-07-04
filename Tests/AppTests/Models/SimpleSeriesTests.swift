import Foundation
import XCTest

@testable import App

class SimpleSeriesTests: XCTestCase {
    let mockLocation = MockLocation(fips: "mockFips", name: "mockName")
    let mockDate1 = IsoDate(year: 2020, month: 7, day: 4)
    let mockDate2 = IsoDate(year: 2020, month: 7, day: 5)
    let mockDate3 = IsoDate(year: 2020, month: 7, day: 6)
    let mockDate4 = IsoDate(year: 2020, month: 7, day: 7)

    var series: SimpleSeries!

    override func setUp() {
        series = SimpleSeries(location: mockLocation)
    }

    func testSetShouldSetValues() {
        series.set(.cases, to: 1, on: mockDate1)

        XCTAssertEqual(series[mockDate1], [.cases: 1])
    }

    func testShouldAppendValues() {
        series.set(.cases, to: 1, on: mockDate1)
        series.set(.deaths, to: 2, on: mockDate1)
        series.set(.cases, to: 3, on: mockDate2)

        XCTAssertEqual(series[mockDate1], [.cases: 1, .deaths: 2])
        XCTAssertEqual(series[mockDate2], [.cases: 3])
    }

    func testShouldReplaceValues() {
        series.set(.cases, to: 1, on: mockDate1)
        series.set(.cases, to: 2, on: mockDate1)

        XCTAssertEqual(series[mockDate1], [.cases: 2])
    }

    func testShouldDeleteValues() {
        series.set(.cases, to: 1, on: mockDate1)
        series.set(.deaths, to: 2, on: mockDate1)
        series.set(.cases, to: nil, on: mockDate1)

        XCTAssertEqual(series[mockDate1], [.deaths: 2])
    }
}
