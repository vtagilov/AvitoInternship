import Foundation

protocol SearchPresenter: Presenter {
    var view: SearchView? { get set }
    
    func loadProducts()
    func loadCategories()
}

final class SearchPresenterImpl: SearchPresenter {
    weak var view: SearchView?
    
    private let interactor: SearchInteractor
    
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
                    view?.addProducts(products: models)
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
                    view?.showCategories(categories: models)
                }
            }
        }
    }

    func search(text: String) { }
}
