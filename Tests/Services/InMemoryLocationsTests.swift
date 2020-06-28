import Foundation
import XCTest

@testable import App

class InMemoryLocationsTests: XCTestCase {
    func testShouldAddLocations() {
        let mockLocation1 = MockLocation(fips: "fips1", name: "name1")
        let mockLocation2 = MockLocation(fips: "fips2", name: "name2")
        let inMemoryLocations = InMemoryLocations()

        inMemoryLocations.add(mockLocation1)
        inMemoryLocations.add(mockLocation2)

        let allStates = inMemoryLocations.all.compactMap { $0 as? MockLocation }

        XCTAssertTrue(allStates.contains(mockLocation1))
        XCTAssertTrue(allStates.contains(mockLocation2))
    }
}

struct MockLocation: Location {
    var type: LocationType = .state

    let fips: String
    let name: String
}

extension MockLocation: Equatable {}
