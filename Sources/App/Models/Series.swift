import Foundation

protocol Series {
    var location: Location { get }
    var days: [IsoDate: Values] { get set } // TODO make nicer
}

struct SimpleSeries: Series {
    let location: Location

    var days: [IsoDate : Values] = [:]

    init?(location: Location?) {
        guard let location = location else {
            return nil
        }
        self.init(location: location)
    }

    init(location: Location) {
        self.location = location
    }
}
