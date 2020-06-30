import Foundation

protocol Series: Transformable {
    var location: Location { get }
    var dates: [IsoDate] { get }

    subscript(_ date: IsoDate) -> Values? { get }
    subscript(_ valueType: ValueType, on date: IsoDate) -> Int? { get }

    mutating func setValues(to values: Values, on date: IsoDate)
    mutating func set(_ valueType: ValueType, to newValue: Int?, on date: IsoDate)
}

extension Series {
}

struct SimpleSeries: Series {
    subscript(date: IsoDate) -> Values? {
        return days[date]
    }

    mutating func setValues(to values: Values, on date: IsoDate) {
        days[date] = values
    }

    mutating func set(_ valueType: ValueType, to newValue: Int?, on date: IsoDate) {
        if days[date] == nil {
            days[date] = Values()
        }
        days[date]?[valueType] = newValue
    }

    subscript(_ valueType: ValueType, on date: IsoDate) -> Int? {
        return days[date]?[valueType]
    }

    let location: Location
    var dates: [IsoDate] { days.keys.sorted() }

    private var days: [IsoDate : Values] = [:]

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
