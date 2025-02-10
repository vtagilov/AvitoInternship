protocol SearchPresenter: Presenter {
    func loadProducts()
}

final class SearchPresenterImpl: SearchPresenter {

    weak var view: SearchView?

    private let interactor: SearchInteractor

    init(interactor: SearchInteractor) {
        self.interactor = interactor
    }

    func loadProducts() {
        Task {
            let result = await interactor.getProducts()
            switch result {
            case .failure:
                view?.showError(type: .networkError)
            case .success(let models):
                view?.showProducts(products: models)
            }
        }
    }
}
