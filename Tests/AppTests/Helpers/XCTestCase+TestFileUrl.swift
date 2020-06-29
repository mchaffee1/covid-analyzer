import Foundation
import Vapor
import XCTest

extension XCTestCase {
    func testFileUrl(for fileName: String?) -> URL? {
        guard let fileName = fileName else {
            return nil
        }
        let testResourcesPath = "Tests/AppTests/Resources"
        let baseUrl = URL(fileURLWithPath: DirectoryConfig.detect().workDir)
        return baseUrl
            .appendingPathComponent(testResourcesPath)
            .appendingPathComponent(fileName)
    }
}
