import Foundation

protocol Series: Transformable {
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

    func transform(with transform: (SimpleSeries)->(SimpleSeries)) -> SimpleSeries {
        return transform(self)
    }
}

protocol Transformable {
    func transform(with transform: (Self)->(Self)) -> Self
}

extension Transformable {
    func transform(with transform: (Self)->(Self)) -> Self {
        return transform(self)
    }
}
