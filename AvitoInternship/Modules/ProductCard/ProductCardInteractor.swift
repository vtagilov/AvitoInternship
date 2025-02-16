import Foundation
import UIKit

final class ProductCardInteractor: Interactor {
    weak var presenter: ProductCardPresenter!
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchImages(urls: [String]) {
        for url in urls {
            Task {
                let result = await fetchImage(url: url)
                if case .success(let image) = result {
                    presenter.showImage(image)
                } else {
                    presenter.showImage(UIImage.errorImage)
                }
            }
        }
        
    }
    
    private func fetchImage(url: String) async -> NetworkResult<UIImage> {
        let result = await networkManager.fetchData(urlStr: url)
        switch result {
        case .success(let data):
            if let image = UIImage(data: data) {
                return .success(image)
            } else {
                print("ProductCardInteractor. fetchImage Error: Could not create UIImage from data")
                return .failure(.decodeError(nil))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
