import Foundation

extension DateComponents {
    init?(isoDay: String?) {
        guard let isoDayString = isoDay else {
            return nil
        }
        let segments = isoDayString
            .split(separator: "-")
            .map { String($0) }
        guard segments.count == 3,
            let year = Int(segments[0]),
            let month = Int(segments[1]),
            let day = Int(segments[2]) else {
                return nil
        }

        self.init(year: year, month: month, day: day)
    }
}
