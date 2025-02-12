import Foundation
import UIKit

final class SearchInteractor: Interactor {
    weak var presenter: SearchPresenter!
    
    private let networkManager: NetworkManager
    private var categories = [Category]()
    private var fetchedProductsCounter = 0
    private var isProductsLoading = false

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchProducts() async -> NetworkResult<[PreviewProduct]> {
        if isProductsLoading { return .success([]) }
        isProductsLoading = true
        defer { isProductsLoading = false }
        let url = Endpoint.products.urlWithParams([
            .limit: "\(ConfigManager.productsPerRequest)",
            .offset: "\(fetchedProductsCounter)"
        ])
        fetchedProductsCounter += ConfigManager.productsPerRequest
        let result = await networkManager.fetchModel(type: [ProductDTO].self, urlStr: url)
        switch result {
        case .success(let modelsDTO):
            let models = await processProductsDTO(modelsDTO: modelsDTO)
            return .success(models)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchCategories() async -> NetworkResult<[Category]> {
        let url = Endpoint.categories.url
        let result = await networkManager.fetchModel(type: [CategoryDTO].self, urlStr: url)
        switch result {
        case .success(let modelsDTO):
            return await processCategoriesDTO(modelsDTO: modelsDTO)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // MARK: - Private methods

    private func fetchImage(url: String) async -> NetworkResult<UIImage> {
        let result = await networkManager.fetchData(urlStr: url)
        switch result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                print("SearchInteractor. fetchImage Error: Could not create UIImage from data")
                return .failure(.decodeError(nil))
            }
            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func processProductsDTO(modelsDTO: [ProductDTO]) async -> [PreviewProduct] {
        var resultModels = [PreviewProduct]()
        for modelDTO in modelsDTO {
            let category = await getCategory(category: modelDTO.category)
            let image: UIImage
            if let previewImageUrl = modelDTO.images.first {
                switch await fetchImage(url: previewImageUrl) {
                case .success(let fetchedImage):
                    image = fetchedImage
                case .failure(let error):
                    print("SearchInteractor. processCategoriesDTO Error: \(error)")
                    image = UIImage()
                }
            } else {
                print("SearchInteractor. processProductsDTO: \(modelDTO) doesn't have image url")
                image = UIImage()
            }
            let model = PreviewProduct(modelDTO: modelDTO, image: image, category: category)
            resultModels.append(model)
        }
        return resultModels
    }

    private func processCategoriesDTO(modelsDTO: [CategoryDTO]) async -> NetworkResult<[Category]> {
        var resultModels = [Category]()
        for modelDTO in modelsDTO {
            let image: UIImage
            switch await fetchImage(url: modelDTO.image) {
            case .success(let fetchedImage):
                image = fetchedImage
            case .failure(let error):
                print("SearchInteractor. processCategoriesDTO Error: \(error)")
                image = UIImage()
            }
            let model = Category(modelDTO: modelDTO, image: image)
            resultModels.append(model)
        }
        categories += resultModels
        return .success(resultModels)
    }
    
    private func getCategory(category: CategoryDTO) async -> Category {
        if let category = categories.first(where: { $0.id == category.id }) {
            return category
        }
        if case .success(let categories) = await processCategoriesDTO(modelsDTO: [category]) {
            if let category = categories.first {
                return category
            }
        }
        return Category.unknown
    }
}
