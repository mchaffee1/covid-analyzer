import Foundation
import XCTest

@testable import App

class InMemoryLocationsTests: XCTestCase {
    let mockLocation1 = MockLocation(fips: "fips1", name: "name1")
    let mockLocation2 = MockLocation(fips: "fips2", name: "name2")

    var inMemoryLocations: InMemoryLocationsDataset!

    override func setUp() {
        super.setUp()
        inMemoryLocations = InMemoryLocationsDataset()

        inMemoryLocations.add(mockLocation1)
        inMemoryLocations.add(mockLocation2)
    }

    func testShouldAddLocations() {
        let allStates = inMemoryLocations.all.compactMap { $0 as? MockLocation }

        XCTAssertTrue(allStates.contains(mockLocation1))
        XCTAssertTrue(allStates.contains(mockLocation2))
    }

    func testShouldReturnLocationForFips() {
        XCTAssertEqual(inMemoryLocations.location(forFips: "fips2") as? MockLocation, mockLocation2)
        XCTAssertNil(inMemoryLocations.location(forFips: "larry"))
    }
}
