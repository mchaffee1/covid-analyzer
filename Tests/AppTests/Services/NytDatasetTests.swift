import Foundation
import Vapor
import XCTest

@testable import App

class NytDatasetTests: XCTestCase {
    func testShouldLoadStateFile() {
        guard let fileUrl = testFileUrl(for: "three-states.csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let mockSeriesDataset = MockSeriesDataset()

        let rows = try? NytDataset(locations: mockLocations, seriesDataset: mockSeriesDataset, sourceFile: fileUrl).rows

        XCTAssertEqual(rows, expectedStateRows)
        XCTAssertEqual(mockLocations.addedLocations as? [State], expectedStates)

        expectedStateRows
            .map { try! State(fips: $0.fips, name: $0.state) }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? State }
                    .contains(expectedLocation))
        }
    }

    func testShouldLoadCountyFile() {
        guard let fileUrl = testFileUrl(for: "three-counties.csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let mockSeriesDataset = MockSeriesDataset()

        let rows = try? NytDataset(locations: mockLocations, seriesDataset: mockSeriesDataset, sourceFile: fileUrl).rows

        XCTAssertEqual(rows, expectedCountyRows)
        XCTAssertEqual(mockLocations.addedLocations as? [County], expectedCounties)

        expectedCountyRows
            .compactMap { try? County(fips: $0.fips, name: $0.county, state: $0.state) }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? County }
                    .contains(expectedLocation))
        }
    }

    func testShouldLoadNationFile() {
        guard let fileUrl = testFileUrl(for: "us-three.csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let mockSeriesDataset = MockSeriesDataset()

        let rows = try? NytDataset(locations: mockLocations, seriesDataset: mockSeriesDataset, sourceFile: fileUrl).rows

        XCTAssertEqual(rows, expectedNationRows)
        XCTAssertEqual(mockLocations.addedLocations as? [Nation], expectedNation)

        expectedNationRows
            .compactMap { _ in Nation(fips: "US-THREE", name: "US-THREE") }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? Nation }
                    .contains(expectedLocation))
        }
    }

    /// MARK: - Helpers
    /// MARK: File Stub Expectations
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

    let expectedStates: [State] = [
        try? State(fips: "53", name: "Washington"),
        try? State(fips: "18", name: "Indiana"),
        try? State(fips: "56", name: "Wyoming"),
        try? State(fips: "56", name: "Wyoming") // TODO remove after deduplicating add's
        ].compactMap { $0 }

    let expectedCountyRows: [RawLoadableRow] = [
        RawLoadableRow(date: IsoDate(year: 2020, month: 3, day: 10),
                       county: "Westchester",
                       state: "New York",
                       fips: "36119",
                       cases: 107,
                       deaths: 0)!,
        RawLoadableRow(date: IsoDate(year: 2020, month: 4, day: 8),
                       county: "Carroll",
                       state: "Maryland",
                       fips: "24013",
                       cases: 186,
                       deaths: 18)!,
        RawLoadableRow(date: IsoDate(year: 2020, month: 4, day: 15),
                       county: "Virginia Beach city",
                       state: "Virginia",
                       fips: "51810",
                       cases: 256,
                       deaths: 5)!
    ]
    let expectedCounties: [County] = [
        try? County(fips: "36119", name: "Westchester", state: "New York"),
        try? County(fips: "24013", name: "Carroll", state: "Maryland"),
        try? County(fips: "51810", name: "Virginia Beach city", state: "Virginia")
        ].compactMap { $0 }

    let expectedNationRows: [RawLoadableRow] = [
        RawLoadableRow(date: IsoDate(year: 2020, month: 1, day: 21),
                       state: nil,
                       fips: "US-THREE",
                       cases: 1,
                       deaths: 0)!,
        RawLoadableRow(date: IsoDate(year: 2020, month: 3, day: 24),
                       state: nil,
                       fips: "US-THREE",
                       cases: 53938,
                       deaths: 785)!,
        RawLoadableRow(date: IsoDate(year: 2020, month: 5, day: 26),
                       state: nil,
                       fips: "US-THREE",
                       cases: 1689250,
                       deaths: 98937)!
    ]
    // TODO OMG dedup buildLocations() call
    let expectedNation: [Nation] = [
        Nation(fips: "US-THREE", name: "US-THREE"),
        Nation(fips: "US-THREE", name: "US-THREE"),
        Nation(fips: "US-THREE", name: "US-THREE"),
    ]
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
    func importRows(from rawDataset: [RawLoadableRow]) {
        //
    }

    func getSeries(forFips: String) -> SimpleSeries? {
        return nil
    }
}
