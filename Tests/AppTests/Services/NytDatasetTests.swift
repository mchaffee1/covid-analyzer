import Foundation
import Vapor
import XCTest

@testable import App

class NytDatasetTests: XCTestCase {
    func testShouldLoadStateFile() {
        let expectedStateRows: [RawLoadableRow] = [
            RawLoadableRow(date: IsoDate(year: 2020, month: 1, day: 21),
                           state: "Washington",
                           fips: "53",
                           cases: 1,
                           deaths: 0)!,
            RawLoadableRow(date: IsoDate(year: 2020, month: 3, day: 23),
                           state: "Indiana",
                           fips: "18",
                           cases: 264,
                           deaths: 12)!,
            RawLoadableRow(date: IsoDate(year: 2020, month: 6, day: 26),
                           state: "Wyoming",
                           fips: "56",
                           cases: 1368,
                           deaths: 20)!,
            RawLoadableRow(date: IsoDate(year: 2020, month: 6, day: 27),
                           state: "Wyoming",
                           fips: "56",
                           cases: 1375,
                           deaths: 20)!
        ]
        let expectedLocations: [State] = [
            State(fips: "53", name: "Washington"),
            State(fips: "18", name: "Indiana"),
            State(fips: "56", name: "Wyoming"),
            State(fips: "56", name: "Wyoming") // TODO remove after deduplicating add's
        ]
        guard let fileUrl = testFileUrl(for: "three-states.csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let mockSeriesDataset = MockSeriesDataset()

        let stateRows = try? NytDataset(locations: mockLocations, seriesDataset: mockSeriesDataset, sourceFile: fileUrl).stateRows

        XCTAssertEqual(stateRows, expectedStateRows)
        XCTAssertEqual(mockLocations.addedLocations as? [State], expectedLocations)

        expectedStateRows
            .map { State(fips: $0.fips, name: $0.state) }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? State }
                    .contains(expectedLocation))
        }
    }
}

class MockLocations: LocationsDataset {
    var locationForFipsCallCount = 0
    var locationForFipsLastFips: String?
    var locationForFipsMockLocation: Location?
    func location(forFips fips: String) -> Location? {
        locationForFipsCallCount += 1
        locationForFipsLastFips = fips
        return locationForFipsMockLocation
    }

    var addCallCount = 0
    var addedLocations = [Location]()
    func add(_ location: Location) {
        addCallCount += 1
        addedLocations.append(location)
    }

    var all: [Location] = []
}

class MockSeriesDataset: SeriesDataset {
    func build(from rawDataset: [RawLoadableRow]) {
        //
    }

    func getSeries(forFips: String) -> SimpleSeries? {
        return nil
    }
}
