import Foundation
import Vapor

protocol Locations {
    var all: [Location] { get }
    func add(_: Location)
}

class InMemoryLocations: Locations {
    func add(_ location: Location) {
        locations[location.name] = location
    }

    private var locations: [String: Location] = [:]

    var all: [Location] { [Location](locations.values) }
}

extension InMemoryLocations: Service {}
