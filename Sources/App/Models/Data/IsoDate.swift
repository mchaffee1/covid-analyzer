import Foundation

struct IsoDate {
    let year: Int
    let month: Int
    let day: Int

    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    init?(year: Int?, month: Int?, day: Int?) {
        guard let year = year,
            let month = month,
            let day = day else {
                return nil
        }
        self.init(year: year, month: month, day: day)
    }

    init?(isoString: String?) {
        guard let segments = isoString?
            .split(separator: "-")
            .map({ substring in String(substring) }),
            segments.count == 3,
            let year = Int(segments[0]),
            let month = Int(segments[1]),
            let day = Int(segments[2]) else {
                return nil
        }

        self.init(year: year, month: month, day: day)
    }

    var description: String {
        String(year) +
            "-" + String(month).leftPad(toLength: 2, withPad: "0") +
            "-" + String(day).leftPad(toLength: 2, withPad: "0")
    }
}

extension IsoDate: RawRepresentable {
    init?(rawValue: String) {
        self.init(isoString: rawValue)
    }

    var rawValue: String {
        return description
    }

    typealias RawValue = String
}

extension IsoDate: Codable {}

extension IsoDate: Equatable {}

extension IsoDate: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }
}

extension IsoDate: Comparable {
    // TODO validate month/day values, or else maybe leverage Date/Calendar?
    static func < (lhs: IsoDate, rhs: IsoDate) -> Bool {
        if lhs.year == rhs.year {
            if lhs.month == rhs.month {
                return lhs.day < rhs.day
            } else {
                return lhs.month < rhs.month
            }
        } else {
            return lhs.year < rhs.year
        }
    }
}
