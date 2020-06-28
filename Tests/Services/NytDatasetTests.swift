import Foundation
import XCTest

@testable import App

class NytDatasetTests: XCTestCase {
    func testShouldLoadFile() {
        let expectedStateRows: [StateRow] = [
            StateRow(date: IsoDate(year: 2020, month: 1, day: 21),
                     state: "Washington",
                     fips: "53",
                     cases: 1,
                     deaths: 0)!,
            StateRow(date: IsoDate(year: 2020, month: 3, day: 23),
                     state: "Indiana",
                     fips: "18",
                     cases: 264,
                     deaths: 12)!,
            StateRow(date: IsoDate(year: 2020, month: 6, day: 26),
                     state: "Wyoming",
                     fips: "56",
                     cases: 1368,
                     deaths: 20)!
            ]
        guard let fileUrl = testBundleUrl(forResource: "us-states", withExtension: "csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let mockLocations = MockLocations()
        let stateRows = try? NytDataset(locations: mockLocations, sourceFile: fileUrl).stateRows

        XCTAssertEqual(stateRows, expectedStateRows)
        XCTAssertEqual(mockLocations.addCallCount, 3)
        expectedStateRows
            .map { $0.location }
            .forEach { expectedLocation in
                XCTAssertTrue(mockLocations.addedLocations
                    .compactMap { $0 as? State }
                    .contains(expectedLocation))
        }
    }

    func testBundleUrl(forResource resourceName: String?, withExtension fileExtension: String?) -> URL? {
        let testBundle = Bundle(for: type(of: self ))
        return testBundle.url(forResource: resourceName, withExtension: fileExtension)
    }
}

class MockLocations: Locations {
    var addCallCount = 0
    var addedLocations = [Location]()
    func add(_ location: Location) {
        addCallCount += 1
        addedLocations.append(location)
    }

    var all: [Location] = []
}
