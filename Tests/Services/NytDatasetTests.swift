import Foundation
import XCTest

@testable import App

class NytDatasetTests: XCTestCase {
    func testShouldLoadFile() {
        let expectedStateRows: [StateRow] = [
            StateRow(date: DateComponents(year: 2020, month: 1, day: 21),
                     state: "Washington",
                     fips: "53",
                     cases: 1,
                     deaths: 0)!,
            StateRow(date: DateComponents(year: 2020, month: 3, day: 23),
                     state: "Indiana",
                     fips: "18",
                     cases: 264,
                     deaths: 12)!,
            StateRow(date: DateComponents(year: 2020, month: 6, day: 26),
                     state: "Wyoming",
                     fips: "56",
                     cases: 1368,
                     deaths: 20)!
            ]
        guard let fileUrl = testBundleUrl(forResource: "us-states", withExtension: "csv") else {
            XCTFail("could not get fileUrl")
            return
        }
        let stateRows = try? NytDataset(sourceFile: fileUrl).stateRows

        XCTAssertEqual(stateRows, expectedStateRows)
    }

    func testBundleUrl(forResource resourceName: String?, withExtension fileExtension: String?) -> URL? {
        let testBundle = Bundle(for: type(of: self ))
        return testBundle.url(forResource: resourceName, withExtension: fileExtension)
    }
}
