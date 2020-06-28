import Foundation

protocol Series {
    var location: Location { get }
    var datePoints: [IsoDate: Values] { get set } // TODO make nicer
}

typealias Values = [ValueType: Int]

enum ValueType: String {
    case cases
    case deaths
    case newCases
    case newCases7day
}

extension ValueType: Codable {}

struct SimpleSeries: Series {
    let location: Location

    var datePoints: [IsoDate : Values] = [:]

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
