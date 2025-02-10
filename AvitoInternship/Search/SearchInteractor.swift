import Foundation

final class SearchInteractor: Interactor {
    typealias AllProductsResult = Result<[ProductDTO], NetworkError>

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getProducts() async -> NetworkResult<[ProductDTO]> {
        let urlStr = Endpoints.products
        guard let url = URL(string: urlStr) else {
            return .failure(.badURL(urlStr))
        }
        let result = await networkManager.fetchData(type: [ProductDTO].self, url: url)
        return result
    }
}
