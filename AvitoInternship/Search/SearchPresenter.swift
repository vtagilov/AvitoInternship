import Foundation

protocol SearchPresenter: Presenter {
    var view: SearchView? { get set }
    
    func loadProducts()
    func loadCategories()
    
    func getCategory(id: Int) -> Category
}

final class SearchPresenterImpl: SearchPresenter {

    weak var view: SearchView?

    private let interactor: SearchInteractor
    private var categories = [Category]()

    init(interactor: SearchInteractor) {
        self.interactor = interactor
        loadCategories()
    }

    func loadProducts() {
        Task {
            let result = await interactor.fetchProducts()
            DispatchQueue.main.async { [weak view] in
                switch result {
                case .failure:
                    view?.showError(type: .networkError)
                case .success(let models):
                    view?.showProducts(products: models)
                }
            }
        }
    }

    func loadCategories() {
        Task {
            let result = await interactor.fetchCategories()
            DispatchQueue.main.async { [weak view] in
                switch result {
                case .failure:
                    view?.showError(type: .networkError)
                case .success(let models):
                    self.categories = models
                    view?.showCategories(categories: models)
                }
            }
        }
    }
    
    func getCategory(id: Int) -> Category {
        if let category = categories.first(where: { $0.id == id }) {
            return category
        }
        return Category.unknown
    }

    func search(text: String) { }
}
