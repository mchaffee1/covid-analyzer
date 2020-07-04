import Foundation

protocol Series: Transformable {
    var location: Location { get }
    var dates: [IsoDate] { get }

    // TODO should this subscript return a non-optional Day?
    subscript(_ date: IsoDate) -> Values? { get }
    subscript(_ valueType: ValueType, on date: IsoDate) -> Int? { get }

    // TODO rename to set
    mutating func set(values: Values, on date: IsoDate)
    mutating func set(_ valueType: ValueType, to newValue: Int?, on date: IsoDate)
}

extension Series {
}

struct SimpleSeries: Series {
    subscript(date: IsoDate) -> Values? {
        return days[date]?.values
    }

    // TODO probably remove?  This set-everything might be an artifact from a series being just a dict
    mutating func set(values: Values, on date: IsoDate) {
        let day = self.day(for: date)
        self.days[date] = day.setting(values)
    }

    mutating func set(_ valueType: ValueType, to newValue: Int?, on date: IsoDate) {
        let day = self.day(for: date)
        guard let newValue = newValue else {
            days[date] = day.removing(valueType)
            return
        }
        self.days[date] = day.setting([valueType: newValue])
    }

    subscript(_ valueType: ValueType, on date: IsoDate) -> Int? {
        return days[date]?.values[valueType]
    }

    let location: Location
    var dates: [IsoDate] { days.keys.sorted() }

    private var days: [IsoDate : Day] = [:]

    private func day(for date: IsoDate) -> Day {
        days[date] ?? Day(location: location, date: date)
    }

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
