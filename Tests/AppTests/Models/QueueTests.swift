import Foundation
import XCTest

@testable import App

class QueueTests: XCTestCase {
    func testShouldEnqueueAndDequeueTwoValues() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)

        XCTAssertEqual(queue.values, [2, 1])

        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertEqual(queue.dequeue(), nil)
    }

    func testShouldEnforceCapacity() {
        var queue = Queue<Int>(capacity: 2)
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        queue.enqueue(4)

        XCTAssertEqual(queue.values, [4, 3])
    }

    func testShouldReportCount() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)

        XCTAssertEqual(queue.count, 2)
    }
}
