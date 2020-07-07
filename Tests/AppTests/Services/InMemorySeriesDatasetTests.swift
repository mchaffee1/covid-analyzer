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
        let stateFips = "stateFips"
        mockLocationsDataset.mockLocationForFips = try! State(fips: stateFips, name: "mock")
        inMemorySeriesDataset.importRows(from: eightDayStateSequence(forFips: stateFips))

        let countyFips = "countyFips"
        mockLocationsDataset.mockLocationForFips = try! County(fips: countyFips, name: "mockCounty", state: "mockCountyState")
        inMemorySeriesDataset.importRows(from: threeDayCountySequence(forFips: countyFips))

        let day1 = IsoDate(year: 2020, month: 1, day: 1)
        let day7 = IsoDate(year: 2020, month: 1, day: 7)
        let day8 = IsoDate(year: 2020, month: 1, day: 8)

        let stateSeries = inMemorySeriesDataset.getSeries(forFips: stateFips)

        XCTAssertEqual(stateSeries?.dates.count, 8)
        XCTAssertEqual(stateSeries?[.newCases, on: day1], 10)
        XCTAssertEqual(stateSeries?[.newCases7dayAverage, on: day7], 10)
        XCTAssertEqual(stateSeries?[.newCases7dayTotal, on: day7], 70)
        XCTAssertEqual(stateSeries?[.newCases7dayAverage, on: day8], 20)
        XCTAssertEqual(stateSeries?[.newCases7dayTotal, on: day8], 140)

        let countySeries = inMemorySeriesDataset.getSeries(forFips: countyFips)

        XCTAssertEqual(countySeries?.dates.count, 3)
        XCTAssertEqual(countySeries?[.newCases, on: day1], 15)
    }

    /// MARK: - Helpers
    func eightDayStateSequence(forState state: String? = nil, forFips fips: String? = nil) -> [RawLoadableRow] {
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

    func threeDayCountySequence(forCounty county: String? = nil, inState state: String? = nil, forFips fips: String? = nil) -> [RawLoadableRow] {
        let county = county ?? "county"
        let state = state ?? "state"
        let fips = fips ?? "fips"
        return [
            RawLoadableRow(date: IsoDate(isoString: "2020-01-01"),
                           county: county,
                           state: state,
                           fips: fips,
                           cases: 15,
                           deaths: 15),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-02"),
                           county: county,
                           state: state,
                           fips: fips,
                           cases: 30,
                           deaths: 0),
            RawLoadableRow(date: IsoDate(isoString: "2020-01-03"),
                           county: county,
                           state: state,
                           fips: fips,
                           cases: 45,
                           deaths: 10)
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
