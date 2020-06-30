import Foundation

extension Dictionary {
    mutating func decorate(withKey key: Key, value: Value) {
        guard self[key] == nil else {
            return
        }
        self[key] = value
    }

    func decorated(withKey key: Key, value: Value) -> Dictionary<Key, Value> {
        var result = self
        result.decorate(withKey: key, value: value)
        return result
    }
}
