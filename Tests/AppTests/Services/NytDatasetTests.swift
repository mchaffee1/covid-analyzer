import Foundation
import Vapor
import XCTest

@testable import App

class NytDatasetTests: XCTestCase {
    func testShouldLoadFile() {
        let expectedStateRows: [RawStateRow] = [
            RawStateRow(date: IsoDate(year: 2020, month: 1, day: 21),
                     state: "Washington",
                     fips: "53",
                     cases: 1,
                     deaths: 0)!,
            RawStateRow(date: IsoDate(year: 2020, month: 3, day: 23),
                     state: "Indiana",
                     fips: "18",
                     cases: 264,
                     deaths: 12)!,
            RawStateRow(date: IsoDate(year: 2020, month: 6, day: 26),
                     state: "Wyoming",
                     fips: "56",
                     cases: 1368,
                     deaths: 20)!
            ]
        guard let fileUrl = testFileUrl(for: "three-states.csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let mockSeriesDataset = MockSeriesDataset()
        let stateRows = try? NytDataset(locations: mockLocations, seriesDataset: mockSeriesDataset, sourceFile: fileUrl).stateRows

        XCTAssertEqual(stateRows, expectedStateRows)
        XCTAssertEqual(mockLocations.addCallCount, 3)
        expectedStateRows
            .map { $0.location }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? State }
                    .contains(expectedLocation as! State))
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
