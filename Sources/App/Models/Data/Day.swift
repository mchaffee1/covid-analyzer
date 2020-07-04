import Foundation

struct Day {
    let location: Location
    let date: IsoDate
    let values: Values

    init(location: Location, date: IsoDate, values: Values? = nil) {
        self.location = location
        self.date = date
        self.values = values ?? [:]
    }

    func setting(_ addedValues: Values) -> Day {
        let newValues = values.merging(addedValues) { (_, new) in new }
        return Day(location: self.location, date: self.date, values: newValues)
    }

    func removing(_ keys: ValueType...) -> Day {
        let newValues = values.filter { (key, _) in
            !keys.contains(key)
        }
        return Day(location: self.location,
                   date: self.date,
                   values: newValues)
    }
}
