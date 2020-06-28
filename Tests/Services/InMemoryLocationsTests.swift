import Foundation
import XCTest

@testable import App

class InMemoryLocationsTests: XCTestCase {
    let mockLocation1 = MockLocation(fips: "fips1", name: "name1")
    let mockLocation2 = MockLocation(fips: "fips2", name: "name2")

    var inMemoryLocations: InMemoryLocations!

    override func setUp() {
        super.setUp()
        inMemoryLocations = InMemoryLocations()

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

struct MockLocation: Location {
    var type: LocationType = .state

    let fips: String
    let name: String
}

extension MockLocation: Equatable {}
