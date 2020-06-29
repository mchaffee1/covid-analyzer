import Foundation
import Vapor
import XCTest

@testable import App

class InMemorySeriesDatasetTests: XCTestCase {
    var mockLocationsDataset: MockLocationsDataset!
    var inMemorySeriesDataset: InMemorySeriesDataset!

    override func setUp() {
        mockLocationsDataset = MockLocationsDataset()
        inMemorySeriesDataset = InMemorySeriesDataset(locations: mockLocationsDataset)
    }

    func testShouldBuildHappyPath() {
        let fips = "fips"
        mockLocationsDataset.mockLocationForFips = State(fips: fips, name: "mock")
        inMemorySeriesDataset.build(from: eightDaySequence(forFips: fips))
        let day1 = IsoDate(year: 2020, month: 1, day: 1)
        let day7 = IsoDate(year: 2020, month: 1, day: 7)
        let day8 = IsoDate(year: 2020, month: 1, day: 8)

        let series = inMemorySeriesDataset.getSeries(forFips: fips)

        XCTAssertEqual(series?.days.count, 8)
        XCTAssertEqual(series?.days[day1]?[.newCases], 10)
        XCTAssertEqual(series?.days[day7]?[.newCases7day], 10)
        XCTAssertEqual(series?.days[day8]?[.newCases7day], 20)
    }

    /// MARK: - Helpers
    func eightDaySequence(forState state: String? = nil, forFips fips: String? = nil) -> [RawLoadableRow] {
        let state = state ?? "myState"
        let fips = fips ?? "myFips"
        return [
            RawLoadableRow(date: IsoDate(isoString: "2020-01-01"),
                           state: state,
                           fips: fips,
                           cases: 10,
                           deaths: 10),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-02"),
                           state: state,
                           fips: fips,
                           cases: 20,
                           deaths: 10),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-03"),
                           state: state,
                           fips: fips,
                           cases: 30,
                           deaths: 10),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-04"),
                           state: state,
                           fips: fips,
                           cases: 40,
                           deaths: 15),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-05"),
                           state: state,
                           fips: fips,
                           cases: 50,
                           deaths: 20),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-06"),
                           state: state,
                           fips: fips,
                           cases: 60,
                           deaths: 20),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-07"),
                           state: state,
                           fips: fips,
                           cases: 70,
                           deaths: 20),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-08"),
                           state: state,
                           fips: fips,
                           cases: 150,
                           deaths: 80),
            ].compactMap { $0 }
    }
}

class MockLocationsDataset: LocationsDataset {
    var all: [Location] = []

    var addCallCount = 0
    var addedLocations = [Location]()
    func add(_ location: Location) {
        addCallCount += 1
        addedLocations.append(location)
    }

    var locationForFipsCallCount = 0
    var mockLocationForFips: Location?
    func location(forFips: String) -> Location? {
        locationForFipsCallCount += 1
        return mockLocationForFips
    }
}
