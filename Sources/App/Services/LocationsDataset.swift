import Foundation

protocol LocationsDataset {
    var all: [Location] { get }
    func add(_: Location)
    func location(forFips: String) -> Location?
}

class InMemoryLocationsDataset: LocationsDataset {
    func location(forFips fips: String) -> Location? {
        return locations[fips]
    }

    func add(_ location: Location) {
        locations[location.fips] = location
    }

    private var locations: [String: Location] = [:]

    var all: [Location] { [Location](locations.values) }
}

