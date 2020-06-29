import Foundation

extension Array where Element == Int {
    func sum() -> Int {
        return self.reduce(0) { $0 + $1 }
    }
}
