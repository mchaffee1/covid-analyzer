import Foundation

struct Queue<Element> {
    let capacity: Int?

    private(set) var values: [Element] = []

    var count: Int { values.count }

    init(capacity: Int? = nil) {
        self.capacity = capacity
    }

    mutating func enqueue(_ element: Element) {
        values.insert(element, at: 0)
        guard let capacity = self.capacity else { return }

        while values.count > capacity {
            _ = self.dequeue()
        }
    }

    mutating func dequeue() -> Element? {
        return values.popLast()
    }
}
