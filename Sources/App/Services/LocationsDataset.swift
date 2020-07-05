import Foundation
import NIO

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

    func hydratePopulation(from populationProvider: PopulationProvider) {

    }

    private var locations: [String: Location] = [:]

    var all: [Location] { [Location](locations.values) }
}

protocol PopulationProvider {

}
