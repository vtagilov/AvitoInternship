import Foundation
import UIKit

final class SearchInteractor: Interactor {
    weak var presenter: SearchPresenter!
    
    var categories = [Category]()
    
    private let networkManager: NetworkManager
    
    private var fetchedProductsCounter = 0
    private var lastProductsRequestTitle: String?
    private var lastFilters: FilterContext?
    private var productsTask: Task<NetworkResult<[PreviewProduct]>, Never>? {
        didSet { oldValue?.cancel() }
    }

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchProducts(
        title: String?
    ) async -> NetworkResult<[PreviewProduct]> {
        productsTask?.cancel()
        fetchedProductsCounter = 0
        lastProductsRequestTitle = title
        productsTask = nil
        defer { productsTask = nil }
        let url = Endpoint.products.urlWithParams([
            .limit: "\(ConfigManager.productsPerRequest)",
            .offset: "\(fetchedProductsCounter)",
            .title: title
        ], lastFilters)
        fetchedProductsCounter += ConfigManager.productsPerRequest
        
        productsTask = Task {
            let result = await networkManager.fetchModel(type: [ProductDTO].self, urlStr: url)
            switch result {
            case .success(let modelsDTO):
                let models = await processProductsDTO(modelsDTO: modelsDTO)
                return .success(models)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return await productsTask!.value
    }
    
    func fetchMoreProducts() async -> NetworkResult<[PreviewProduct]> {
        if productsTask != nil { return .failure(.alreadyLoading) }
        let url = Endpoint.products.urlWithParams([
            .limit: "\(ConfigManager.productsPerRequest)",
            .offset: "\(fetchedProductsCounter)",
            .title: lastProductsRequestTitle
        ], lastFilters)
        fetchedProductsCounter += ConfigManager.productsPerRequest
        
        productsTask = Task {
            let result = await networkManager.fetchModel(type: [ProductDTO].self, urlStr: url)
            switch result {
            case .success(let modelsDTO):
                let models = await processProductsDTO(modelsDTO: modelsDTO)
                return .success(models)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return await productsTask!.value
    }
    
    func fetchProductsWithFilters(context: FilterContext? = nil) async -> NetworkResult<[PreviewProduct]> {
        productsTask?.cancel()
        fetchedProductsCounter = 0
        lastFilters = context
        productsTask = nil
        defer { productsTask = nil }
        let url = Endpoint.products.urlWithParams([
            .limit: "\(ConfigManager.productsPerRequest)",
            .offset: "\(fetchedProductsCounter)",
            .title: lastProductsRequestTitle
        ], context)
        fetchedProductsCounter += ConfigManager.productsPerRequest
        
        productsTask = Task {
            let result = await networkManager.fetchModel(type: [ProductDTO].self, urlStr: url)
            switch result {
            case .success(let modelsDTO):
                let models = await processProductsDTO(modelsDTO: modelsDTO)
                return .success(models)
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return await productsTask!.value
    }
    
    func fetchCategories() {
        Task {
            let url = Endpoint.categories.url
            let result = await networkManager.fetchModel(type: [CategoryDTO].self, urlStr: url)
            if case .success(let modelsDTO) = result {
                DispatchQueue.main.async {
                    let models = modelsDTO.map { Category(modelDTO: $0) }
                    self.categories += models
                }
            }
        }
    }
    
    // MARK: - Private methods

    private func fetchImage(url: String) async -> NetworkResult<UIImage> {
        let result = await networkManager.fetchData(urlStr: url)
        switch result {
        case .success(let data):
            if let image = UIImage(data: data) {
                return .success(image)
            } else {
                print("SearchInteractor. fetchImage Error: Could not create UIImage from data")
                return .success(UIImage.errorImage)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @MainActor
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
                    print("SearchInteractor. processProductsDTO Error: \(error)")
                    image = UIImage.errorImage
                }
            } else {
                print("SearchInteractor. processProductsDTO: \(modelDTO) doesn't have image url")
                image = UIImage.errorImage
            }
            let model = PreviewProduct(modelDTO: modelDTO, image: image, category: category)
            resultModels.append(model)
        }
        productsTask = nil
        return resultModels
    }

    private func getCategory(category: CategoryDTO) async -> Category {
        if let category = categories.first(where: { $0.id == category.id }) {
            return category
        }
        let category = Category(modelDTO: category)
        categories += [category]
        return category
    }
}
