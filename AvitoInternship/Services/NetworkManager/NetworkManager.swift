import Foundation

enum NetworkError: Error {
    case badURL(String)
    case unknown(Error)
    case network(URLError)
    case decodeError(Error)
}

typealias NetworkResult<T: Decodable> = Result<T, NetworkError>

final class NetworkManager {

    public func fetchData<T: Decodable>(type: T.Type, url: URL) async -> NetworkResult<T> {
        do {
            let result = try await URLSession.shared.data(from: url)
            return decodeData(data: result.0)
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
