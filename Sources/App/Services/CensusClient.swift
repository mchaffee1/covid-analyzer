import Foundation
import NIO

typealias Matrix<Element> = [[Element]]

class CensusClient {
    private var cache: [String: CensusLocation]? = nil

    func getRawStates(on eventLoop: EventLoop) -> EventLoopFuture<[String: CensusLocation]> {
        let promise = eventLoop.newPromise(of: [String: CensusLocation].self)
        getRawStates {
            promise.succeed(result: $0)
        }
        return promise.futureResult
    }

    func getRawStates(completion: (([String: CensusLocation])->())? = nil) {
        guard let cacheCopy = self.cache else {
            fetchRawStates(completion: completion)
            return
        }
        completion?(cacheCopy)
    }

    func fetchRawStates(completion: (([String: CensusLocation])->())? = nil) {
        guard let url = URL(string: "https://api.census.gov/data/2019/pep/population?get=POP,NAME&for=state") else { completion?([:])
            return
        }

        let request: URLRequest = {
            var result = URLRequest(url: url)
            result.httpMethod = "GET"
            return result
        }()

        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            let censusStates = self.decode(states: data)
            completion?(censusStates)
        }.resume()
    }

    private func decode(states: Data?) -> [String: CensusLocation] {
        guard let stateData = states,
            let stateMatrix = try? JSONDecoder().decode(Matrix<String>.self, from: stateData) else {
                return [:]
        }
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let pairs = dictArray(from: stateMatrix)
            // TODO not classy
            .compactMap { try? encoder.encode($0) }
            .compactMap { try? decoder.decode(CensusLocation.self, from: $0) }
            .map { (fips: $0.fips, censusState: $0) }
        return Dictionary(uniqueKeysWithValues: pairs)
    }

    // TODO move to array extension
    func dictArray(from matrix: [[String]]) -> [[String: String]] {
        guard let header = matrix.first else {
            return []
        }

        return matrix.dropFirst().map { row in
            Dictionary(uniqueKeysWithValues: zip(header, row))
        }
    }
}
