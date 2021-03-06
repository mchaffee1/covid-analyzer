import Foundation
import Vapor

protocol Dataset {}

extension Dataset {
    func resourceFileURL(forFilename fileName: String) -> URL {
        return resourceDirectoryURL.appendingPathComponent(fileName)
    }

    var resourceDirectoryURL: URL {
        let baseUrl = URL(fileURLWithPath: DirectoryConfig.detect().workDir)
        return baseUrl.appendingPathComponent("Sources/App/Resources/")
    }
}
