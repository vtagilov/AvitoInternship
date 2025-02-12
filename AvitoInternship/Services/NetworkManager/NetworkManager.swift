import Foundation

enum NetworkError: Error {
    case badURL(String)
    case unknown(Error?)
    case network(URLError)
    case decodeError(Error?)
}

typealias NetworkResult<T> = Result<T, NetworkError>

final class NetworkManager {

    public func fetchModel<T: Decodable>(type: T.Type, urlStr: String) async -> NetworkResult<T> {
        let dataResult = await fetchData(urlStr: urlStr)
        switch dataResult {
        case .success(let data):
            return decodeData(data: data)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func fetchData(urlStr: String) async -> NetworkResult<Data> {
        guard let url = URL(string: urlStr) else {
            return .failure(.badURL(urlStr))
        }
        print("REQUEST URL: \(url)")
        do {
            let result = try await URLSession.shared.data(from: url)
            print("REQUEST (\(url). RESULT: \(result)")
            return .success(result.0)
        } catch let urlError as URLError {
            return .failure(.network(urlError))
        } catch {
            return .failure(.unknown(error))
        }
    }

    private func decodeData<T: Decodable>(data: Data) -> NetworkResult<T> {
        let decodeResult = JSONDecoderService.shared.decode(T.self, from: data)
        switch decodeResult {
        case .success(let model):
            return .success(model)
        case .failure(let error):
            return .failure(.decodeError(error))
        }
    }
}
