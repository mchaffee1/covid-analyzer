import Foundation
import Vapor

class LocationsController {
    func index(_ req: Request) throws -> [LocationResponse] {
        let locations = try req.make(Locations.self)

        return locations.all.map { LocationResponse(location: $0) }
    }
}

struct LocationResponse: Location, Content {
    let type: LocationType
    let fips: String
    let name: String

    init(location: Location) {
        self.type = location.type
        self.fips = location.fips
        self.name = location.name
    }
}
