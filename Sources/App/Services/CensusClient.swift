import Foundation

typealias Matrix<Element> = [[Element]]

class CensusClient {
    func getRawStates(completion: (([String: CensusState])->())? = nil) {
        guard let url = URL(string: "https://api.census.gov/data/2019/pep/population?get=POP,NAME&for=state") else { completion?([:])
            return
        }

        let request: URLRequest = {
            var result = URLRequest(url: url)
            result.httpMethod = "GET"
            return result
        }()

        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            completion?(self.decode(states: data))
        }.resume()
    }

    private func decode(states: Data?) -> [String: CensusState] {
        guard let stateData = states,
            let stateMatrix = try? JSONDecoder().decode(Matrix<String>.self, from: stateData) else {
                return [:]
        }
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let pairs = dictArray(from: stateMatrix)
            // TODO not classy
            .compactMap { try? encoder.encode($0) }
            .compactMap { try? decoder.decode(CensusState.self, from: $0) }
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
