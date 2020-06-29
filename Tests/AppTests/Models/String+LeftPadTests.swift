import Foundation
import XCTest

@testable import App

class String_LeftPadTests: XCTestCase {
    func testShouldNotChangeLongerString() {
        XCTAssertEqual("Hello".leftPad(toLength: 4, withPad: "x"), "Hello")
    }

    func testShouldPadToTarget() {
        XCTAssertEqual("AB".leftPad(toLength: 5, withPad: "x"), "xxxAB")
    }
}
