import Foundation
import Vapor

class LocationsController {
    func index(_ req: Request) throws -> [LocationResponse] {
        let locationsDataset = try req.make(LocationsDataset.self)

        return locationsDataset.all
            .map { LocationResponse(location: $0) }
            .filter(queryFilter(req.query[String.self, at: "q"]))
    }

    func queryFilter(_ queryText: String?) -> LocationResponseFilter {
        guard let queryText = queryText else {
            return { _ in true }
        }

        return { locationResponse in
            locationResponse.name.uppercased().contains(queryText.uppercased())
        }
    }
}

typealias LocationResponseFilter = (LocationResponse)->(Bool)

struct LocationResponse: Location, Content {
    let type: LocationType
    let fips: String
    let name: String

    init(location: Location) {
        self.type = location.type
        self.fips = location.fips
        self.name = location.name
    }

    static let empty = LocationResponse(location: State.empty)
}
