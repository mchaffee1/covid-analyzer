import Foundation

public extension String {
    func leftPad(toLength length: Int, withPad pad: Character) -> String {
        let padCount = length - self.count
        guard padCount > 0 else {
            return self
        }
        return String(repeating: pad, count: padCount) + self
    }
}
